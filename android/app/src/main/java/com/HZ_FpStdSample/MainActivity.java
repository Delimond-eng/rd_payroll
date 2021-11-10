package com.HZ_FpStdSample;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.HZFINGER.HAPI;
import com.HZFINGER.HostUsb;
import com.HZFINGER.LAPI;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;



public class MainActivity extends FlutterActivity {

    private static final String CHANNEL= "com.flutter.medpad";

    private HostUsb mHostUSb = null;
    private LAPI m_cLAPI = null;
    private long m_hDevice = 0;
    private HAPI m_cHAPI = null;
    private byte[] m_iso_template = new byte[LAPI.FPINFO_STD_MAX_SIZE];
    private ScreenBroadcastReceiver mScreenReceiver;
    private Context mContext;

    private JSONArray empreintes=new JSONArray();

    public static int num = 0;

    private byte[] m_image = new byte[LAPI.WIDTH* LAPI.HEIGHT];
    private volatile boolean bContinue = false;
    private int[] RGBbits = new int[256 * 360];
    private String args= "";

    @Override
    protected void onCreate(Bundle bundle){
        super.onCreate(bundle);
    }

    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {

        GeneratedPluginRegistrant.registerWith(flutterEngine);

        mContext = this;
        mScreenReceiver = new ScreenBroadcastReceiver();
        registerListener();

        new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL).setMethodCallHandler(
                (methodCall, result) -> {
                    m_cLAPI = new LAPI(MainActivity.this);
                    mHostUSb = new HostUsb(MainActivity.this);
                    m_cHAPI = new HAPI(mContext);

                    if (methodCall.method.equals("openDevice")) {
                        openDevice();
                    }
                    if(methodCall.method.equals("closeDevice")){

                        closeDevice(result);
                    }

                    if(methodCall.method.equals("open_usb_device")){
                        openCircuit();
                    }

                    if(methodCall.method.equals("close_usb_device")){
                        closeCircuit();
                    }

                    if(methodCall.method.equals("get_image"))
                    {
                        openDevice();
                        new OperationEnroll().execute(result);
                    }

                    if(methodCall.method.equals("match_fingers"))
                    {
                        openDevice();
                        args= methodCall.arguments();
                        new OperationScan().execute(result);
                    }
                }
        );
    }

    private boolean isFingerDevice(UsbDevice device){
        int vid = device.getVendorId();
        int pid = device.getProductId();
        if(vid == LAPI.VID && pid == LAPI.PID){
            return true;
        }
        return false;
    }

    private void registerListener() {
        if (mContext != null) {
            IntentFilter filter = new IntentFilter();
            filter.addAction(Intent.ACTION_SCREEN_OFF);
            filter.addAction(UsbManager.ACTION_USB_DEVICE_ATTACHED);
            filter.addAction(UsbManager.ACTION_USB_DEVICE_DETACHED);
            //filter.addAction(HostUsb.ACTION_USB_PERMISSION);
            mContext.registerReceiver(mScreenReceiver, filter);
        }
    }

    private void openCircuit(){
        try{
            Intent intent = new Intent("android.intent.action.ChangeHotonReceiver");
            sendBroadcast(intent);

            Intent intent2 = new Intent("android.intent.action.lightonReceiver");
            sendBroadcast(intent2);
        }
        catch(Exception ex){
            Log.e("error", ex.getMessage());
        }
    }

    private void closeCircuit(){
        try{
            Intent intent = new Intent("android.intent.action.ChangeHotoffReceiver");
            sendBroadcast(intent);

            Intent intent2 = new Intent("android.intent.action.lightoffReceiver");
            sendBroadcast(intent2);
        }
        catch(Exception ex){
            Log.e("error", ex.getMessage());
        }
    }

    private  void openDevice(){
        try {
            UsbDevice dev = mHostUSb.hasDeviceOpen();
            if (dev != null)
            {
                m_cLAPI.setHostUsb(mHostUSb);
                mHostUSb.AuthorizeDevice(dev);
            }
            m_hDevice = m_cLAPI.OpenDeviceEx();
            //m_hDevice = d;
            if(m_hDevice == 0){
                Log.e("error", "Echec openning device");
            }
            else{
                Toast.makeText(mContext,"Dispositif d'empreinte lancé",Toast.LENGTH_LONG).show();
            }
            m_cHAPI.m_hDev = m_hDevice;
        }
        catch(Exception ex){
            Log.i("message error", ex.getMessage());
        }

    }

    private void closeDevice(MethodChannel.Result res){
        try {
            int ret = m_cLAPI.CloseDeviceEx(m_hDevice);

            if(ret == 0 ){
                res.success("Device is closed !");
            }
        }
        catch(Exception ex){
            Log.e("error", ex.getMessage());
        }
    }

    private class ScreenBroadcastReceiver extends BroadcastReceiver {
        private String action = null;
        @Override
        public void onReceive(Context context, Intent intent) {
            action = intent.getAction();
            if (Intent.ACTION_SCREEN_OFF.equals(action))
            {
                onDestroy();
                finish();
            }
            else if (UsbManager.ACTION_USB_DEVICE_ATTACHED.equals(action))
            {
                UsbDevice newDevice = (UsbDevice)intent.getParcelableExtra(UsbManager.EXTRA_DEVICE);
                if (newDevice != null && isFingerDevice(newDevice)) {
                    m_cLAPI.setHostUsb(mHostUSb);
                    if(!mHostUSb.AuthorizeDevice(newDevice)){
                        Toast.makeText(context,"Dispositif attaché",Toast.LENGTH_LONG).show();
                        //openDevice();
                    }
                }
            }
            else if (UsbManager.ACTION_USB_DEVICE_DETACHED.equals(action))
            {
                UsbDevice oldDevice = (UsbDevice)intent.getParcelableExtra(UsbManager.EXTRA_DEVICE);
                if (oldDevice != null && isFingerDevice(oldDevice)) {
                    m_cLAPI.setHostUsb(null);
                    Toast.makeText(context,"Dispositif detaché !",Toast.LENGTH_LONG).show();
                }
            }
        }
    }
    
    private byte[] arrangeBytes(byte[] image, int width, int height){
        if (width==0)
        {
            return null;
        }
        if (height==0)
        {
            return null;
        }
        for (int i = 0; i < width * height; i++ )
        {
            int v;
            if (image != null)
            {
                v = image[i] & 0xff;
            }
            else
            {
                v = 255;
            }

            //RGBbits[i] = Color.rgb(v, v, v);
            if (v < 128)
            {
                RGBbits[i] = Color.rgb(50, 100, 255);
            }
            else
            {
                RGBbits[i] = Color.rgb(255, 255, 255);
            }
        }
        Bitmap bmp = Bitmap.createBitmap(RGBbits, width, height, Bitmap.Config.RGB_565);

        ByteArrayOutputStream byteArrayOutputStream=new ByteArrayOutputStream();
        bmp.compress(Bitmap.CompressFormat.PNG,100,byteArrayOutputStream);
        byte[] bytesCompressed=byteArrayOutputStream.toByteArray();
        return bytesCompressed;

    }

    private class OperationScan extends AsyncTask<MethodChannel.Result, Void, Integer>{
        MethodChannel.Result result;

        @Override
        protected Integer doInBackground(MethodChannel.Result... results) {
            result = results[0];
            bContinue = true;
            boolean hasFinger = scanFinger();
            if(hasFinger){
                //String args = methodCall.arguments();
                try{
                    empreintes = new JSONArray(args);
                    //new MatchFinger().execute(result);
                    int patientId= matchFinger();
                    return patientId;

                }
                catch(Exception e){
                    Log.e("error", e.getMessage());
                }
            }
            else {
                    return -1;
            }
            return 0;
        }

        @Override
        protected void onPostExecute(Integer integer)
        {
            super.onPostExecute(integer);
            int patientId=(int) integer; /** patient ID de l'empreinte trouvé */

            if(patientId == -1){
                Toast.makeText(mContext,"Empreinte mal posée !",Toast.LENGTH_LONG).show();
            }
            result.success(""+patientId);
        }

        private boolean scanFinger(){
            try {
                while (bContinue)
                {
                    int ret = m_cLAPI.GetImage(m_hDevice, m_image);
                    if(ret == LAPI.NOTCALIBRATED){
                        Toast.makeText(mContext,"Not calibrated !",Toast.LENGTH_LONG).show();
                        break;
                    }

                    if(ret != LAPI.TRUE){
                        Toast.makeText(mContext,"Can not Get image !",Toast.LENGTH_LONG).show();
                        break;
                    }

                    ret = m_cLAPI.IsPressFinger(m_hDevice, m_image);

                    if(ret >= LAPI.DEF_FINGER_SCORE){
                        int score = m_cLAPI.GetNFIQuality(m_hDevice, m_image);
                        if(score !=0 && score !=1){
                            return false;
                        }
                        else{
                            //break;
                            return true;
                        }
                    }

                }
                bContinue = false;
            }
            catch(Exception ex){
                Log.e("error", ex.getMessage());
            }

            return false;
        }

        private void getImage(MethodChannel.Result result){
            try {
                while (bContinue)
                {
                    int ret = m_cLAPI.GetImage(m_hDevice, m_image);
                    if(ret == LAPI.NOTCALIBRATED){
                        Toast.makeText(mContext,"Not calibrated !",Toast.LENGTH_LONG).show();
                        break;
                    }

                    if(ret != LAPI.TRUE){
                        Toast.makeText(mContext,"Can not Get image !",Toast.LENGTH_LONG).show();
                        break;
                    }

                    ret = m_cLAPI.IsPressFinger(m_hDevice, m_image);

                    if(ret >= LAPI.DEF_FINGER_SCORE){

                        byte[] imgByte = arrangeBytes(m_image, LAPI.WIDTH, LAPI.HEIGHT);
                        List<byte[]> list = new ArrayList<>();
                        int template = m_cLAPI.CreateISOTemplate(m_hDevice, m_image, m_iso_template);
                        int score = m_cLAPI.GetNFIQuality(m_hDevice, m_image);

                        if(score == 0 || score==1){
                            if(template != 0){
                                list.add(imgByte);
                                list.add(m_iso_template);
                                result.success(list);
                            }
                            break;
                        }
                        else{
                            Toast.makeText(mContext,"Empreinte mal posée !",Toast.LENGTH_LONG).show();
                            break;
                        }

                    }
                }
                bContinue = false;
            }
            catch(Exception ex){
                Log.e("error", ex.getMessage());
            }
        }


        protected int matchFinger()
        {
            //result = results[0];
            int highestScore=0;
            /** créer la template de finger */
            byte[] fingerTemplate=new byte[LAPI.FPINFO_STD_MAX_SIZE];
            int n=m_cLAPI.CreateISOTemplate(m_hDevice,m_image, fingerTemplate);
            if(n==0)
            {
                return 0;
            }

            ArrayList<JSONObject> allScores=new ArrayList<>();
            for(int i=0; i<empreintes.length(); i++)
            {
                try
                {
                    JSONObject data=empreintes.getJSONObject(i);
                    String empreinte_1=data.getString("empreinte_1");
                    String empreinte_2=data.getString("empreinte_2");
                    String empreinte_3=data.getString("empreinte_3");

                    ArrayList<byte[]> templates=new ArrayList<>();

                    /** convertir en bytes non compressé */
                    byte[] empreinteTemplate_1= Base64.decode(empreinte_1,Base64.DEFAULT);
                    byte[] empreinteTemplate_2=Base64.decode(empreinte_2,Base64.DEFAULT);
                    templates.add(empreinteTemplate_1);
                    templates.add(empreinteTemplate_2);

                    if(empreinte_3!=null)
                    {
                        byte[] empreinteTemplate_3=Base64.decode(empreinte_3,Base64.DEFAULT);
                        templates.add(empreinteTemplate_3);
                    }

                    /** Matching du Finger template avec les templates de ces empreintes */
                    int score=0;
                    for(int i_2=0; i_2<templates.size(); i_2++)
                    {
                        //score += m_cLAPI.CompareTemplates(m_hDevice,fingerTemplate,templates.get(i_2));
                        int empreinteScore = m_cLAPI.CompareTemplates(m_hDevice,fingerTemplate,templates.get(i_2));

                        if(empreinteScore>score)
                        {
                            score=empreinteScore; /** recuperer l'empreinte ayant le plus grande score pour ce patient */
                        }
                    }

                    /** classifier ces score pour comparaison */
                    JSONObject scoreData=new JSONObject();
                    scoreData.put("empreinte_id",data.getString("empreinte_id"));
                    scoreData.put("score",score);

                    allScores.add(scoreData);

                }catch(Exception e){}
            }

            /** comparaison des scores */

            highestScore=0;
            int empreinteId=0;
            for(int i=0; i<allScores.size(); i++)
            {
                JSONObject scoreData=allScores.get(i);
                int score= 0;
                try
                {
                    score = scoreData.getInt("score");

                    if(score>highestScore)
                    {
                        highestScore=score;
                        empreinteId=Integer.parseInt(scoreData.getString("empreinte_id"));
                    }

                } catch (JSONException e)
                {
                    return 0;
                }
            }

            if(highestScore <= 60){
                return 0;
            }
            return empreinteId; /** patientId */
        }
    }

    private class OperationEnroll extends AsyncTask<MethodChannel.Result, Void, Void>{
        MethodChannel.Result result;
        List<byte[]> list = null;
        @Override
        protected Void doInBackground(MethodChannel.Result... results) {
            result = results[0];
            bContinue = true;
            getImage();
            return null;
        }
        @Override
        protected void onPostExecute(Void s){
            super.onPostExecute(s);
            if(list==null){
                Toast.makeText(mContext,"Empreinte mal posée !",Toast.LENGTH_LONG).show();
            }
            else{
                result.success(list);
            }
        }
        private void getImage(){
            try {
                while (bContinue)
                {
                    int ret = m_cLAPI.GetImage(m_hDevice, m_image);
                    if(ret == LAPI.NOTCALIBRATED){
                        Toast.makeText(mContext,"Not calibrated !",Toast.LENGTH_LONG).show();
                        break;
                    }

                    if(ret != LAPI.TRUE){
                        Toast.makeText(mContext,"Can not Get image !",Toast.LENGTH_LONG).show();
                        break;
                    }

                    ret = m_cLAPI.IsPressFinger(m_hDevice, m_image);

                    if(ret >= LAPI.DEF_FINGER_SCORE){

                        byte[] imgByte = arrangeBytes(m_image, LAPI.WIDTH, LAPI.HEIGHT);
                        list = new ArrayList<>();
                        int template = m_cLAPI.CreateISOTemplate(m_hDevice, m_image, m_iso_template);
                        int score = m_cLAPI.GetNFIQuality(m_hDevice, m_image);

                        if(score == 0 || score==1){
                            if(template != 0){
                                list.add(imgByte);
                                list.add(m_iso_template);
                            }
                            break;
                        }
                        else{

                            break;
                        }

                    }
                }
                bContinue = false;
            }
            catch(Exception ex){
                Log.e("error", ex.getMessage());
            }
        }

    }


}
