---
layout: post
title:  "How to manage solutions using manager"
categories: iot
lab: iot
author: DavidTONeill
lang: en
---

# Introduction

In this tutorial we assume you already have a Runabove Account and have subscribed to the IOT lab.
 
## What is a solution?
 
A solution is a container for your data and has a set of tokens to manage this data. 
You can separate your data in different solutions or keep it in a single container depending on your need. 
For example, you could create a solution named 'house-temperature' that contains one token per sensor. 
You can also create a solution named 'Cellar' that will contain one token for humidity and temperature respectively.
 
## What is a token?
 
Tokens are used for authentication and authorization. 
They have a write key (used to push data) and a read key (used to retrieve data). 
Each token belong to a specific solution.

# How to create a new solution

First you must use your favorite browser to access the [Runabove Manager](https://cloud.runabove.com).

![main-page](/kb/images/2015-08-10-how-to-manage-solutions-using-runabove-manager/main-page.png)

In the left menu, click on "Internet of Things"

![main-page](/kb/images/2015-08-10-how-to-manage-solutions-using-runabove-manager/empty-solution-page.png)

After creating a solution, it will be displayed in this page.
Select the upper right button named "Add a new solution".

![solution-creation-page](/kb/images/2015-08-10-how-to-manage-solutions-using-runabove-manager/solution-creation-page.png)

Enter the name, description and cluster of your new solution.

- The name can contain only alphanumeric characters and dash and are case sensitive.
- The cluster is the location where your data are stored.

Select ok

![solution-creation-page](/kb/images/2015-08-10-how-to-manage-solutions-using-runabove-manager/solution-page.png)

# How to modify a solution

On the IOT solutions page click on the cog icon on the right side of the table.

![main-page](/kb/images/2015-08-10-how-to-manage-solutions-using-runabove-manager/solution-row.png)

You cannot modify the name or cluster of a solution after its creation.
  
![solution-modification-page](/kb/images/2015-08-10-how-to-manage-solutions-using-runabove-manager/solution-modification-page.png)

Select OK

# How to delete a solution

On the IOT solutions page click on the trash icon on the right of the table.

![solution-row](/kb/images/2015-08-10-how-to-manage-solutions-using-runabove-manager/solution-row.png)

You can click OK to permanently delete the solution.

# How to create a new token

First you must use your favorite browser to access the [Runabove Manager](https://cloud.runabove.com).

![main-page](/kb/images/2015-08-10-how-to-manage-solutions-using-runabove-manager/main-page.png)

Select the name of your already created solution to access his token list.

![token-page](/kb/images/2015-08-10-how-to-manage-solutions-using-runabove-manager/token-page.png)

Select the "Create token" top right button

![token-creation-page](/kb/images/2015-08-10-how-to-manage-solutions-using-runabove-manager/token-creation-page.png)

- The expiration date is the date which your token will expire and become unusable, it must be in the future.
- A tag is a pair of key/value that will be included as metadata. It is useful to retrieve specific data.
For example, if I have a token with tag type:humidity and another one with tag type:temperature,
 i can easily retrieve the specific data for type:temperature.

Select ok

# How to modify a token

On the IOT token list page select the cog icon on the right of the table.

![token-row](/kb/images/2015-08-10-how-to-manage-solutions-using-runabove-manager/token-row.png)

You can modify the token name and his tags

![token-modification-page](/kb/images/2015-08-10-how-to-manage-solutions-using-runabove-manager/token-modification-page.png)

Select OK

# How to delete a token

On the IOT solutions page click on the trash icon on the right of the table.

![token-row](/kb/images/2015-08-10-how-to-manage-solutions-using-runabove-manager/token-row.png)

Select OK to permanently delete the token.