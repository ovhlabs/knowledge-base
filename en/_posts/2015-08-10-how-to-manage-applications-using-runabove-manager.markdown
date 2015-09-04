---
layout: post
title:  "How to manage applications using manager"
categories: iot
author: DavidTONeill
lang: en
---

# Requirements

In this tutorial we assume you already have a RunAbove Account and have subscribed to the IoT lab.

# What is an application?

An application is a container for your data and has a set of tokens to manage this data. On Runabove IOT Lab, you can store a numeric data with its timestamp and its metadata.
You can store your data in different applications or keep it in a single application depending on your need.
For example, you could create an application named 'house-temperature' that contains one token per sensor.
You can also create an application named 'Cellar' that will contain one token for humidity and temperature respectively.

# What is a token?

Tokens are used for authentication and authorization. 
They have a write key (used to push data) and a read key (used to retrieve data).
Each token belong to a specific application.

# How to create a new application

First you must use your favorite browser to access the [RunAbove Manager](https://cloud.runabove.com).

![main-page][1]

In the left menu, click on "Internet of Things"

![main-page][2]

After creating an application, it will be displayed in this page.
Select the upper right button named "Add a new application".

![application-creation-page][3]

Enter the name, description and cluster of your new application.

- The name can contain only alphanumeric characters and dash and are case sensitive.
- The cluster is the location where your data are stored.

Select ok

![application-creation-page][4]

# How to modify an application

On the IoT applications page click on the cog icon on the right side of the table.

![main-page][5]

You cannot modify the name or cluster of an application after its creation.

![application-modification-page][6]

Select OK

# How to delete an application

On the IoT applications page click on the trash icon on the right of the table.

![application-row][5]

You can click OK to permanently delete the application.

# How to create a new token

First you must use your favorite browser to access the [RunAbove Manager](https://cloud.runabove.com).

![main-page][1]

Select the name of your already created application to access his token list.

![token-page][7]

Select the "Create token" top right button

![token-creation-page][8]

- The expiration date is the date which your token will expire and become unusable, it must be in the future.
- A tag is a pair of key/value that will be included as metadata. It is useful to retrieve specific data.
For example, if I have a token with tag type:humidity and another one with tag type:temperature,
 i can easily retrieve the specific data for type:temperature.

Select ok

# How to modify a token

On the IoT token list page select the cog icon on the right of the table.

![token-row][9]

You can modify the token name and his tags

![token-modification-page][10]

Select OK

# How to delete a token

On the IoT applications page click on the trash icon on the right of the table.

![token-row][9]

Select OK to permanently delete the token.

  [1]: /kb/images/2015-08-10-how-to-manage-applications-using-runabove-manager/main-page.png
  [2]: /kb/images/2015-08-10-how-to-manage-applications-using-runabove-manager/empty-application-page.png
  [3]: /kb/images/2015-08-10-how-to-manage-applications-using-runabove-manager/application-creation-page.png
  [4]: /kb/images/2015-08-10-how-to-manage-applications-using-runabove-manager/application-page.png
  [5]: /kb/images/2015-08-10-how-to-manage-applications-using-runabove-manager/application-row.png
  [6]: /kb/images/2015-08-10-how-to-manage-applications-using-runabove-manager/application-modification-page.png
  [7]: /kb/images/2015-08-10-how-to-manage-applications-using-runabove-manager/token-page.png
  [8]: /kb/images/2015-08-10-how-to-manage-applications-using-runabove-manager/token-creation-page.png
  [9]: /kb/images/2015-08-10-how-to-manage-applications-using-runabove-manager/token-row.png
  [10]: /kb/images/2015-08-10-how-to-manage-applications-using-runabove-manager/token-modification-page.png
