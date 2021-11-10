//Edited
package com.HZFINGER;

import java.util.HashMap;

import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.usb.UsbConstants;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbDeviceConnection;
import android.hardware.usb.UsbEndpoint;
import android.hardware.usb.UsbInterface;
import android.hardware.usb.UsbManager;
import android.util.Log;
import android.widget.Toast;

public class HostUsb
{
    private static final String TAG = "OpenHostUsb";
    private static final boolean D = true;

    public static final String ACTION_USB_PERMISSION = "com.HZFINGER.USB_PERMISSION";

    private Context mContext = null;
    private UsbManager mDevManager = null;
    private UsbInterface intf = null;
    private UsbDeviceConnection connection = null;
    private static UsbDevice device = null;

    private int m_nEPOutSize = 2048;
    private int m_nEPInSize = 2048;
    private byte[] m_abyTransferBuf = new byte[2048];

    UsbEndpoint endpoint_IN = null;
    UsbEndpoint endpoint_OUT = null;
    UsbEndpoint endpoint_INT = null;
    UsbEndpoint curEndpoint = null;

    public HostUsb(Context context) {

        mContext = context ;
        mDevManager = ((UsbManager) mContext.getSystemService(Context.USB_SERVICE));

        if (D) Log.e(TAG, "news:" + "mDevManager");
    }

    public UsbDevice hasDeviceOpen(int VID, int PID){

        if(mDevManager != null) {
            HashMap<String, UsbDevice> deviceList = mDevManager.getDeviceList();
            for (UsbDevice tdevice : deviceList.values()) {
                if (tdevice.getVendorId() == VID && (tdevice.getProductId() == PID)) return tdevice ;
            }
        }

        return null;
    }

    public UsbDevice hasDeviceOpen(){

        return hasDeviceOpen(LAPI.VID, LAPI.PID);
    }

    public boolean AuthorizeDevice(int VID, int PID)
    {

        if(mDevManager != null) {

            HashMap<String, UsbDevice> deviceList = mDevManager.getDeviceList();

            for (UsbDevice tdevice : deviceList.values()) {
                if (D) Log.e(TAG, "news:" + tdevice);

                if (tdevice.getVendorId() == VID && (tdevice.getProductId() == PID))
                {
                    boolean hasPermission = mDevManager.hasPermission(tdevice);
                    if (!hasPermission) {
                        PendingIntent permissionIntent = PendingIntent.getBroadcast(mContext, 0, new Intent(ACTION_USB_PERMISSION), 0);
                        mContext.registerReceiver(mUsbReceiver, new IntentFilter(ACTION_USB_PERMISSION));
                        mContext.registerReceiver(mUsbReceiver, new IntentFilter(UsbManager.ACTION_USB_DEVICE_DETACHED));
                        mDevManager.requestPermission(tdevice, permissionIntent);
                        return true;
                    } else {
                        device = tdevice;
                        return true;
                    }
                }
            }
        }

        return false;
    }

    public void registerReceiver(){

        if(mContext != null) {
            IntentFilter filter = new IntentFilter();
            filter.addAction(ACTION_USB_PERMISSION);
            //filter.addAction(UsbManager.ACTION_USB_DEVICE_ATTACHED);
            //filter.addAction(UsbManager.ACTION_USB_DEVICE_DETACHED);
            mContext.registerReceiver(mUsbReceiver, filter);
        }
    }

    public void unregisterReceiver() {

        if (mContext != null){
            mContext.unregisterReceiver(mUsbReceiver);
        }
    }

    public boolean AuthorizeDevice(UsbDevice dev)
    {

        if(mDevManager != null)
        {
            boolean hasPermission = mDevManager.hasPermission(dev);
            if (!hasPermission)
            {

                PendingIntent permissionIntent = PendingIntent.getBroadcast(mContext, 0, new Intent(ACTION_USB_PERMISSION), 0);
                mContext.registerReceiver(mUsbReceiver, new IntentFilter(ACTION_USB_PERMISSION));
                mContext.registerReceiver(mUsbReceiver, new IntentFilter(UsbManager.ACTION_USB_DEVICE_DETACHED));
                mDevManager.requestPermission(dev, permissionIntent);
                return false;
            }
            else {
                device = dev;
                return true;
            }
        }

        return false;
    }

    public boolean AuthorizeDevice() {

        return this.device != null && AuthorizeDevice(this.device);
    }

    public boolean AuthorizeDevice(UsbDevice dev,Context context)
    {
        if(mDevManager != null)
        {
            boolean hasPermission = mDevManager.hasPermission(dev);
            if (!hasPermission)
            {
                Toast.makeText(context,"USB Permission not given",Toast.LENGTH_LONG).show();
                PendingIntent permissionIntent = PendingIntent.getBroadcast(mContext, 0, new Intent(ACTION_USB_PERMISSION), 0);
                mContext.registerReceiver(mUsbReceiver, new IntentFilter(ACTION_USB_PERMISSION));
                mContext.registerReceiver(mUsbReceiver, new IntentFilter(UsbManager.ACTION_USB_DEVICE_DETACHED));
                mDevManager.requestPermission(dev, permissionIntent);
                return false;
            }
            else
            {
                device = dev;
                Toast.makeText(context,"USB Permission  given",Toast.LENGTH_LONG).show();
                return true;
            }
        }

        return false;
    }

    private final BroadcastReceiver mUsbReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (ACTION_USB_PERMISSION.equals(action))
            {
                synchronized (this) {
                    device = (UsbDevice) intent	.getParcelableExtra(UsbManager.EXTRA_DEVICE);
                    if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)) {
                        if (device != null) {
                            //Toast.makeText(context,"Permission USB Authorized ",Toast.LENGTH_LONG).show();
                            if (D) Log.e(TAG, "Authorize permission " + device);
                        }
                    }
                    else
                    {
                        //Toast.makeText(context,"Permission USB denied ",Toast.LENGTH_LONG).show();
                        if (D) Log.e(TAG, "permission denied for device " + device);

                    }
                }
            }
        }
    };

    public boolean WaitForInterfaces() {
        while (device == null) {}
        return true;
    }

    public int OpenDeviceInterfaces() {
        UsbDevice mDevice = device;
        Log.d(TAG, "setDevice " + mDevice);
        int fd = -1;

        if (mDevice == null) return -1;

        connection = mDevManager.openDevice(mDevice);
        if (connection == null ||  !connection.claimInterface(mDevice.getInterface(0), true)) return -1;

        if (mDevice.getInterfaceCount() < 1) return -1;
        intf = mDevice.getInterface(0);

        if (intf.getEndpointCount() == 0) 	return -1;

        for (int i = 0; i < intf.getEndpointCount(); i++) {
            if (intf.getEndpoint(i).getType() == UsbConstants.USB_ENDPOINT_XFER_BULK) {
                if (intf.getEndpoint(i).getDirection() == UsbConstants.USB_DIR_IN) {
                    endpoint_IN = intf.getEndpoint(i);
                }
                else if (intf.getEndpoint(i).getDirection() == UsbConstants.USB_DIR_OUT) {
                    endpoint_OUT = intf.getEndpoint(i);
                }
            }
            else if (intf.getEndpoint(i).getType() == UsbConstants.USB_ENDPOINT_XFER_INT) {
                endpoint_INT = intf.getEndpoint(i);
            }
            else {
                if (D) Log.e(TAG, "Not Endpoint or other Endpoint ");
            }
        }
        curEndpoint = intf.getEndpoint(0);

        if ((connection != null)) {
            if (D) Log.e(TAG, "open connection success!");
            fd = connection.getFileDescriptor();
            return fd;
        }
        else {
            if (D) Log.e(TAG, "finger device open connection FAIL");
            return -1;
        }
    }

    public void CloseDeviceInterface() {
        if (connection != null) {
            connection.releaseInterface(intf);
            connection.close();
        }
    }

    public boolean USBBulkSend(byte[] pBuf, int nLen, int nTimeOut)
    {
        int i, n, r, w_nRet;

        n = nLen / m_nEPOutSize;
        r = nLen % m_nEPOutSize;

        for(i=0; i<n; i++)
        {
            System.arraycopy(pBuf, i*m_nEPOutSize, m_abyTransferBuf, 0, m_nEPOutSize);
            w_nRet = connection.bulkTransfer(endpoint_OUT, m_abyTransferBuf, m_nEPOutSize, nTimeOut);
            if (w_nRet != m_nEPOutSize)
                return false;
        }

        if (r > 0)
        {
            System.arraycopy(pBuf, i*m_nEPOutSize, m_abyTransferBuf, 0, r);
            w_nRet = connection.bulkTransfer(endpoint_OUT, m_abyTransferBuf, r, nTimeOut);
            if (w_nRet != r)
                return false;
        }
        return true;
    }

    public boolean USBBulkReceive(byte[] pBuf, int nLen, int nTimeOut)
    {
        int i, n, r, w_nRet;

        n = nLen / m_nEPInSize;
        r = nLen % m_nEPInSize;

        for(i=0; i<n; i++)
        {
            w_nRet = connection.bulkTransfer(endpoint_IN, m_abyTransferBuf, m_nEPInSize, nTimeOut);

            if (w_nRet != m_nEPInSize)
                return false;
            System.arraycopy(m_abyTransferBuf, 0, pBuf, i*m_nEPInSize, m_nEPInSize);
        }

        if (r > 0)
        {
            w_nRet = connection.bulkTransfer(endpoint_IN, m_abyTransferBuf, r, nTimeOut);
            if (w_nRet != r)
                return false;
            System.arraycopy(m_abyTransferBuf, 0, pBuf, i*m_nEPInSize, r);
        }
        return true;
    }
}

