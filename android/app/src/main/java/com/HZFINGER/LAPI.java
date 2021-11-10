//Edited
package com.HZFINGER;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;

import com.HZFINGER.HostUsb;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

public class LAPI {
    static final String TAG = "LAPI";
    //****************************************************************************************************
    static
    {
        try{
            System.loadLibrary("biofp_e_lapi");
            Log.i("LAPI","loadLibray OK");
        }
        catch(UnsatisfiedLinkError e) {
            Log.e("LAPI","loadLibrary failed",e);
        }
    }
    //****************************************************************************************************
    public static final int VID = 0x28E9;
    public static final int PID = 0x028F;
    private static HostUsb m_usbHost = null;
    private static int m_hUSB = 0;
    public static final int MSG_OPEN_DEVICE = 0x10;
    public static final int MSG_CLOSE_DEVICE = 0x11;
    public static final int MSG_BULK_TRANS_IN = 0x12;
    public static final int MSG_BULK_TRANS_OUT = 0x13;
    //****************************************************************************************************
    public static final int WIDTH  = 256;
    public static final int HEIGHT  = 360;
    public static final int IMAGE_SIZE = WIDTH*HEIGHT;
    //****************************************************************************************************
    public static final int FPINFO_STD_MAX_SIZE = 1024;
    public static final int DEF_FINGER_SCORE = 45;
    public static final int DEF_QUALITY_SCORE = 30;
    public static final int DEF_MATCH_SCORE = 45;
    public static final int FPINFO_SIZE = FPINFO_STD_MAX_SIZE;
    //****************************************************************************************************
    public static final int TRUE = 1;
    public static final int FALSE = 0;
    public static final int NOTCALIBRATED = -2;
    //****************************************************************************************************
    public static final int SCSI_MODE = 1;
    public static final int SPI_MODE = 2;
    public static final int VERSION1 = 1;
    public static final int VERSION2 = 2;
    public static final int commMode = SCSI_MODE;//SPI_MODE
    public static final int versionNo = VERSION2;
    //****************************************************************************************************
    //private static Activity m_content = null;
    private static Context m_content=null;

    public void setHostUsb(HostUsb hostUsb){
        m_usbHost = hostUsb ;
    }
    //****************************************************************************************************
    private static int CallBack (int message, int notify, int param, Object data)
    {
        switch (message) {
            case MSG_OPEN_DEVICE:
                if(m_usbHost == null) {
                    m_usbHost = new HostUsb(m_content);

                    if (!m_usbHost.AuthorizeDevice(VID, PID)) {
                        m_usbHost = null;
                        return 0;
                    }
                }

                m_usbHost.WaitForInterfaces();

                m_hUSB = m_usbHost.OpenDeviceInterfaces();
                if (m_hUSB < 0) {
                    m_usbHost = null;
                    return 0;
                }

                return m_hUSB;
            case MSG_CLOSE_DEVICE:
                if (m_usbHost != null) {
                    m_usbHost.CloseDeviceInterface();
                    m_hUSB = -1;
                    m_usbHost = null;
                }
                return 1;
            case MSG_BULK_TRANS_IN:
                if (m_usbHost.USBBulkReceive((byte[])data,notify,param)) return notify;
                return 0;
            case MSG_BULK_TRANS_OUT:
                if (m_usbHost.USBBulkSend((byte[])data,notify,param)) return notify;
                return 0;
        }
        return 0;
    }
    //****************************************************************************************************
    public LAPI(Activity a)
    {
        m_content = a;
    }

    public LAPI(Context context)
    {
        m_content=context;
    }
    //------------------------------------------------------------------------------------------------//
    // Purpose   : This function initializes the Fingerprint Recognition SDK Library and
    //				connects Fingerprint Collection Module.
    // Function  : OpenDevice
    // Arguments : void
    // Return    : long
    //			     If successful, return handle of device, else 0.
    //------------------------------------------------------------------------------------------------//
    private native long OpenDevice(int commMode, int versionNo);
    public long OpenDeviceEx()
    {
        long ret = 0;
        ret = OpenDevice(commMode, versionNo);
        return ret;
    }
    //------------------------------------------------------------------------------------------------//
    // Purpose   : This function finalizes the Fingerprint Recognition SDK Library and
    //				disconnects Fingerprint Collection Module.
    // Function  : CloseDevice
    // Arguments :
    //      (In) : long device : handle returned from function "OpenDevice()"
    // Return    : int
    //			      If successful, return 1, else 0
    //------------------------------------------------------------------------------------------------//
    private  native int CloseDevice(long device);
    public int CloseDeviceEx(long device)
    {
        int ret;
        ret = CloseDevice(device);
        return ret;
    }
    //------------------------------------------------------------------------------------------------//
    // Purpose   : This function returns image captured from Fingerprint Collection Module.
    // Function  : GetImage
    // Arguments :
    //      (In) : long device : handle returned from function "OpenDevice()"
    //  (In/Out) : byte[] image : image captured from this device
    // Return    : int
    //			      If successful, return 1,
    //				  if not calibrated(TCS1/2), return -2,
    //						else, return  0
    //------------------------------------------------------------------------------------------------//
    public native int GetImage(long device, byte[] image);
    //------------------------------------------------------------------------------------------------//
    // Purpose   : This function does calibration of this Fingerprint Collection Module.
    //			   This function is used only for TCS1/TCS2 Sensor.
    // Function  : Calibration
    // Arguments :
    //      (In) : long device : handle returned from function "OpenDevice()"
    //      (In) : int mode : dry/default/wet
    // Return    :
    //			   int :   If successful, return 1, else 0
    //------------------------------------------------------------------------------------------------//
    public native int Calibration(long device, int mode);
    //------------------------------------------------------------------------------------------------//
    // Purpose   : This function checks whether finger is on sensor of this device or not.
    // Function  : IsPressFinger
    // Arguments :
    //      (In) : long device : handle returned from function "OpenDevice()"
    //		(In) : byte[] image : image returned from function "GetImage()"
    // Return    : int
    //				   return percent value indicating that finger is placed on sensor(0~100).
    //------------------------------------------------------------------------------------------------//
    public native int IsPressFinger(long device,byte[] image);
    //------------------------------------------------------------------------------------------------//
    // Purpose   : This function creates the ANSI standard template from the uncompressed raw image.
    // Function  : CreateANSITemplate
    // Arguments :
    //      (In) : long device : handle returned from function "OpenDevice()"
    //		(In) : byte[] image : image returned from function "GetImage()"
    //	(In/Out) : byte[] itemplate : ANSI standard template created from image.
    // Return    : int :
    //				   If this function successes, return none-zero, else 0.
    //------------------------------------------------------------------------------------------------//
    public native int CreateANSITemplate(long device,byte[] image, byte[] itemplate);
    //------------------------------------------------------------------------------------------------//
    // Purpose   : This function creates the ISO standard template from the uncompressed raw image.
    // Function  : CreateISOTemplate
    // Arguments : void
    //      (In) : long device : handle returned from function "OpenDevice()"
    //		(In) : byte[] image : image returned from function "GetImage()"
    //  (In/Out) : byte[] itemplate : ISO standard template created from image.
    // Return    : int :
    //				   If this function successes, return none-zero, else 0.
    //------------------------------------------------------------------------------------------------//
    public native int CreateISOTemplate(long device,byte[] image,  byte[] itemplate);
    //------------------------------------------------------------------------------------------------//
    // Purpose   : This function gets the quality value of fingerprint raw image.
    // Function  : GetImageQuality
    // Arguments :
    //      (In) : long device : handle returned from function "OpenDevice()"
    //		(In) : byte[] image : image returned from function "GetImage()"
    // Return    : int :
    //				   return quality value(0~100) of fingerprint raw image.
    //------------------------------------------------------------------------------------------------//
    public native int GetImageQuality(long device,byte[] image);
    //------------------------------------------------------------------------------------------------//
    // Purpose   : This function gets the NFI quality value of fingerprint raw image.
    // Function  : GetNFIQuality
    // Arguments :
    //      (In) : long device : handle returned from function "OpenDevice()"
    //		(In) : byte[] image : image returned from function "GetImage()"
    // Return    : int :
    //				   return NFI quality value(1~5) of fingerprint raw image.
    //------------------------------------------------------------------------------------------------//
    public native int GetNFIQuality(long device,byte[] image);
    //------------------------------------------------------------------------------------------------//
    // Purpose   : This function matches two templates and returns similar match score.
    //             This function is for 1:1 Matching and only used in fingerprint verification.
    // Function  : CompareTemplates
    // Arguments :
    //      	(In) : long device : handle returned from function "OpenDevice()"
    //			(In) : byte[] itemplateToMatch : template to match :
    //                 This template must be used as that is created by function "CreateANSITemplate()"
    //                 or function "CreateISOTemplate()".
    //			(In) : byte[] itemplateToMatched : template to be matched
    //                 This template must be used as that is created by function "CreateANSITemplate()"
    //                 or function "CreateISOTemplate()".
    // Return    : int
    //					return similar match score(0~100) of two fingerprint templates.
    //------------------------------------------------------------------------------------------------//
    public native int CompareTemplates(long device,byte[] itemplateToMatch, byte[] itemplateToMatched);
    //------------------------------------------------------------------------------------------------//
    // Purpose   : This function matches the appointed ANSI template against to ANSI template array of DATABASE.
    //             This function is for 1:N Matching and only used in fingerprint identification.
    // Function  : SearchingANSITemplates
    // Arguments :
    //      	(In) : long device : handle returned from function "OpenDevice()"
    //			(In) : byte[] itemplateToSearch : template to search
    //                 This template must be used as that is created by function "CreateANSITemplate()".
    //			(In) : byte[] numberOfDbTemplates : number of templates to be searched.
    //			(In) : byte[] arrayOfDbTemplates : template array to be searched.
    //                 These templates must be used as that is created by function "CreateANSITemplate()".
    //			(In) : int scoreThreshold :
    //                 This argument is the threshold of similar match score for 1: N Matching.
    // Return    : int
    //				   If successful, return index number of template searched inside template array,
    //				   else -1.
    //------------------------------------------------------------------------------------------------//
    public native int SearchingANSITemplates(long device, byte[] itemplateToSearch,
                                             int numberOfDbTemplates, byte[] arrayOfDbTemplates, int scoreThreshold);
    //------------------------------------------------------------------------------------------------//
    // Purpose   : This function matches the appointed ISO template against to ISO template array of DATABASE.
    //             This function is for 1:N Matching and only used in fingerprint identification.
    // Function  : SearchingISOTemplates
    // Arguments :
    //      	(In) : long device : handle returned from function "OpenDevice()"
    //			(In) : byte[] itemplateToSearch : template to search
    //                 This template must be used as that is created by function "CreateISOTemplate()".
    //			(In) : byte[] numberOfDbTemplates : number of templates to be searched.
    //			(In) : byte[] arrayOfDbTemplates : template array to be searched.
    //                 These templates must be used as that is created by function "CreateISOTemplate()".
    //			(In) : int scoreThreshold :
    //                 This argument is the threshold of similar match score for 1: N Matching.
    // Return    : int
    //				   If successful, return index number of template searched inside template array,
    //				   else -1.
    //------------------------------------------------------------------------------------------------//
    public native int SearchingISOTemplates(long device, byte[] itemplateToSearch,
                                            int numberOfDbTemplates, byte[] arrayOfDbTemplates, int scoreThreshold);
    //****************************************************************************************************
    public long LoadAsFile(String filename, byte[] buffer)
    {
        long ret = 0;
        // File extStorageDirectory = Environment.getExternalStorageDirectory();
        // File Dir = new File(extStorageDirectory, "Android");
        /*File Dir = m_content.getExternalFilesDir(null);
        File file = new File(Dir, filename);
        ret = file.length();
        try {
            FileInputStream out = new FileInputStream(file);
            out.read(buffer);
            out.close();
        }
        catch (Exception e)
        {
        }*/

        return ret;
    }
    //****************************************************************************************************
    public static boolean SaveAsFile(String filename, byte[] buffer, int len) {
        boolean ret = true;
        //File extStorageDirectory = Environment.getExternalStorageDirectory();
        //File Dir = new File(extStorageDirectory, "Android");
        /*File Dir = m_content.getExternalFilesDir(null);
        File file = new File(Dir, filename);
        try {
            FileOutputStream out = new FileOutputStream(file);
            out.write(buffer, 0, len);
            out.close();
        } catch (Exception e) {
            ret = false;
        }*/

        return ret;
    }
}
