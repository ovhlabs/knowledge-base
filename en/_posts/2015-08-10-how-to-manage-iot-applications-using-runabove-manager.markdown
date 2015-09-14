---
layout: post
title:  "Managing IoT applications with the Runabove Manager"
categories: iot
author: DavidTONeill
lang: en
---

This tutorial assumes you already have a RunAbove account and have subscribed to the [IoT lab](https://www.runabove.com/iot/).

# Concepts

## IoT applications

An application is an isolated container for your metrics data. You can define separate applications for projects that have no relation, e.g. one for greenhouse monitoring in a farm, and another one for all the sensors in a building. Access to the data is defined per application.

If a project or product has multiple tenants that should see only a subset of the data, use a single applications and create separate tokens (see below) for each tenant.

## Access tokens

Tokens are used for authentication and authorization. They have a unique identifier, and contain :

* a name
* a key, used to authenticate the token,
* permissions (read or write),
* tags (key/value pairs) that define the subset in the application's data that can be accessed with the token.

The tags attached to a write token are automatically added to any value written using this token, and the tags attached to a read token are automatically added as filters to any query made with this token. This allows tags to effectively restrict the scope of the token to a subset of the application's data.

Typical use cases for tags:

* with write token tags, enforce a device identifier (or data source), making sure a device cannot write data on behalf of others. It also limits potential data corruption if a device's token is compromised.
* with read tokens tags, restrict visibility of a given user to the devices owned by that user.

# How to create a new application

Go to the [RunAbove Manager](https://cloud.runabove.com) and choose "[Internet of Things](https://cloud.runabove.com/#/iot)" in the left menu.

![main-page][2]

To create your first application, click on the "New application" button in the upper-right corner.

Enter the name, description and cluster of your new application :

* The name can contain only alphanumeric characters and dash and are case sensitive.
* The cluster is the location where your data are stored.

![application-creation-page][3]

Once you click "Ok", the application is shown in the list and is ready for further actions.

![application-creation-page][4]

Use the left column action icons to:

* go to the token list for this application.
* edit the application. Only the name and description can be changed, not the storage location.
* delete the application.

# How to create a new token

From the application list, either select the application name or the key icon. This will show the token management screen.

![token-page][7]

Select the "New token" top right button. In the example below, we create a specific token for the greenhouse's ceiling sensor gateway. The token has a "location" tags that will automatically tag metrics with their origin.

Having a separate token for the ceiling sensors also strengthens the system's security. If that device and its token are compromised, the impact is limited since the token can only write to a narrow subset of the application's full data set.

![token-creation-page][8]

Once you have defined the token's parameters, it is displayed in the application's token list. That list also contain the token's read and write identifier and keys.

![token-list][9]

You can then copy/paste these identifiers and keys to [send data][10] to the metric storage or [query that storage][11].

Use the left column action icons to:

* edit the token's name and tags,
* download a JSON representation the token,
* delete the token.


[1]: /kb/images/2015-08-10-how-to-manage-iot-applications-using-runabove-manager/main-page.png
[2]: /kb/images/2015-08-10-how-to-manage-iot-applications-using-runabove-manager/empty-application-page.png
[3]: /kb/images/2015-08-10-how-to-manage-iot-applications-using-runabove-manager/application-creation-page.png
[4]: /kb/images/2015-08-10-how-to-manage-iot-applications-using-runabove-manager/application-page.png
[5]: /kb/images/2015-08-10-how-to-manage-iot-applications-using-runabove-manager/application-row.png
[6]: /kb/images/2015-08-10-how-to-manage-iot-applications-using-runabove-manager/application-modification-page.png
[7]: /kb/images/2015-08-10-how-to-manage-iot-applications-using-runabove-manager/token-page.png
[8]: /kb/images/2015-08-10-how-to-manage-iot-applications-using-runabove-manager/token-creation-page.png
[9]: /kb/images/2015-08-10-how-to-manage-iot-applications-using-runabove-manager/token-list.png
[10]: how-to-push-data-to-runabove-iot.html
[11]: how-to-get-data-from-runabove-iot.html
