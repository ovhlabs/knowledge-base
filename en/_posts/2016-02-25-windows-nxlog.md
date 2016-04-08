---
layout: post
title:  "Sending Windows Logs with NXLog to PaaS Logs in 15 minutes or less"
categories: Logs
author: Babacar Diassé
lang: en
---


At OVH, we love Microsoft products too. So it is important for us to provide you a way to send your Windows Logs to PaaS Logs. All you need is 15 minutes and one software : [NXLog](http://nxlog.co). NXLog is one of the leader of the log management tools. Its configuration is fairly simple and can get you started in a few minutes. 


For this tutorial you will need to have completed the following steps : 

  - [Activate the PaaS Logs lab and create an account.](/kb/en/logs/quick-start.html#account)
  - [To create at least one Stream and get its token.](/kb/en/logs/quick-start.html#streams)


# NXLog 

You can find NXLog, at its official website [nxlog.co](http://nxlog.co). Please go to the official website and download the latest version for Windows (2.9.1504 at the time of writing). Be sure to have Administrator rights before proceding. Once you have it, install it on your system.  By default the program will install itself in C:\Program Files(x86)\nxlog\\. Navigate to this folder to edit the configuration file `nxlog.conf` present in the folder `conf`.   



# Configuration. 

To configure NXLog, you will need to download the globalsign certificate of our main input. You can find it here [https://laas.runabove.com/certs/global-sign.crt](https://laas.runabove.com/certs/global-sign.crt) (use the right-click then `Save As`). Please put this file under the  `C:\Program Files(x86)\nxlog\cert` folder. For reference it is the GlobalSign Root R1 Certificate : 


```
-----BEGIN CERTIFICATE-----
MIIDdTCCAl2gAwIBAgILBAAAAAABFUtaw5QwDQYJKoZIhvcNAQEFBQAwVzELMAkG
A1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExEDAOBgNVBAsTB1Jv
b3QgQ0ExGzAZBgNVBAMTEkdsb2JhbFNpZ24gUm9vdCBDQTAeFw05ODA5MDExMjAw
MDBaFw0yODAxMjgxMjAwMDBaMFcxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9i
YWxTaWduIG52LXNhMRAwDgYDVQQLEwdSb290IENBMRswGQYDVQQDExJHbG9iYWxT
aWduIFJvb3QgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDaDuaZ
jc6j40+Kfvvxi4Mla+pIH/EqsLmVEQS98GPR4mdmzxzdzxtIK+6NiY6arymAZavp
xy0Sy6scTHAHoT0KMM0VjU/43dSMUBUc71DuxC73/OlS8pF94G3VNTCOXkNz8kHp
1Wrjsok6Vjk4bwY8iGlbKk3Fp1S4bInMm/k8yuX9ifUSPJJ4ltbcdG6TRGHRjcdG
snUOhugZitVtbNV4FpWi6cgKOOvyJBNPc1STE4U6G7weNLWLBYy5d4ux2x8gkasJ
U26Qzns3dLlwR5EiUWMWea6xrkEmCMgZK9FGqkjWZCrXgzT/LCrBbBlDSgeF59N8
9iFo7+ryUp9/k5DPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8E
BTADAQH/MB0GA1UdDgQWBBRge2YaRQ2XyolQL30EzTSo//z9SzANBgkqhkiG9w0B
AQUFAAOCAQEA1nPnfE920I2/7LqivjTFKDK1fPxsnCwrvQmeU79rXqoRSLblCKOz
yj1hTdNGCbM+w6DjY1Ub8rrvrTnhQ7k4o+YviiY776BQVvnGCv04zcQLcFGUl5gE
38NflNUVyRRBnMRddWQVDf9VMOyGj/8N7yy5Y0b2qvzfvGn9LhJIZJrglfCm7ymP
AbEVtQwdpf5pLGkkeB6zpxxxYu7KyJesF12KwvhHhm4qxFYxldBniYUr+WymXUad
DKqC5JlR3XC321Y9YeRq4VzW9v493kHMB65jUr9TU/Qr6cf9tveCX4XSQRjbgbME
HMUfpIBvFSDJ3gyICh3WZlXi/EjJKSZp4A==
-----END CERTIFICATE-----
```

The configuration is pretty much straightforward. Here is the configuration file that allows you to configure your NXLog.  


```
## This is a sample configuration file. See the nxlog reference manual about the
## configuration options. It should be installed locally and is also available
## online at http://nxlog.org/nxlog-docs/en/nxlog-reference-manual.html

## Please set the ROOT to the folder your nxlog was installed into,
## otherwise it will not start.

#define ROOT C:\Program Files\nxlog
define ROOT C:\Program Files (x86)\nxlog
define CERTDIR %ROOT%\cert

Moduledir %ROOT%\modules
CacheDir %ROOT%\data
Pidfile %ROOT%\data\nxlog.pid
SpoolDir %ROOT%\data
LogFile %ROOT%\data\nxlog.log

<Input in>
    Module      im_msvistalog
# For windows 2003 and earlier use the following:
#   Module      im_mseventlog
</Input>

<Processor OVH_TOKEN>
    Module      pm_null
    Exec        $TOKEN='XXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX';
    Exec        rename_field("TOKEN","X-OVH-TOKEN");
</Processor>

<Extension gelf>
    Module xm_gelf
</Extension>

<Output out>
    Module      om_ssl
    Host        laas.runabove.com
    Port        12202
    CAFile      %CERTDIR%\global-sign.crt
    AllowUntrusted FALSE
    OutputType      GELF_TCP
</Output>

<Route 1>
    Path        in => OVH_TOKEN => out
</Route>
```

Let's explain the few important points in this configuration : 

 - The line `define CERTDIR %ROOT%\cert` is mandatory to indicate to NXLog where it will find the globalsign cert of PaaS Logs. 
 - The `Input` part is the same as the default configuration. Do not touch it ;-). 
 - The `Processor` module is where the OVH Token magic happens : Replace your token here. 
 - The `Extension` activate the built-in GELF module that encode the log in the GELF format
 - The `Output` module is the one that will send the logs to PaaS Logs by defining the CA certificate used to trust the server and the encoding used. This is where you use the path of the certificate downloaded juste before. This module also define taht we use the Gelf Encoding. 
 - The `Route` setting put all these things together by building a pipeline using the source, processing and the ouput modules. 

# Start NXLog

You have two ways to start NXLog. The first one is to launch the main Executable : `C:\Program Files(x86)\nxlog\nxlog.exe`. This is convenient when you are pretty sure that your configuration is correct. But if you want to be able to start, stop or restart the nxlog service, It woulid be better to use the Windows Service Manager. This Manager is located deep in the Configuration Panel of Windows. 

Go to `Control Panel`, then locate `Administratives Tools` and then double-click on `Services` to display the manager. In this menu you should find the service nxlog in the list. There is a start, stop and restart action available in the contextual menu (Right-Click on it). 

Excuse my French screenshot detailing where to find it: 

![Restart Screenshot](/kb/images/2016-02-25-windows-nxlog/panel_config.png)


If something bad happens, you will find the logs and a pretty good explanation in the file :  `C:\Program Files(x86)\nxlog\data\nxlog.log`. If everything is correct you should find these kind of lines in the same file : 

```
2016-04-08 19:53:26 INFO connecting to laas.runabove.com:12202
2016-04-08 19:53:26 INFO successfully connected to laas.runabove.com:12202
```

Jump to [Graylog](https://laas.runabove.com/graylog) and to the stream associated to your token to display your logs. As you can see, The Event Log format of windows is already structured and allows you immediately to analyze your services and processes. 


![Graylog Screenshot](/kb/images/2016-02-25-windows-nxlog/graylog.png)


I think that's pretty much it. I know, it didn't even take 10 minutes :-).  

If you want to go further, don't hesitate to fly to the [NXlog documentation](https://nxlog.co/docs/)


#Getting Help

- Getting Started : [Quick Start](/kb/en/logs/quick-start.html)
- Documentation : [Guides](/kb/en/logs)
- Mailing List : [paas.logs-subscribe@ml.ovh.net](mailto:paas.logs-subscribe@ml.ovh.net)
- Visit our community: [community.runabove.com](https://community.runabove.com)
- Create an account: [PaaS Logs Beta](https://cloud.runabove.com/signup/?launch=paas-logs)
