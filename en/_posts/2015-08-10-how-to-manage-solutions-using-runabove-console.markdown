---
layout: post
title:  "How to manage solutions using RunAbove console"
categories: iot
author: DavidTONeill
lang: en
---

# Introduction

In this tutorial we assume you already have a RunAbove Account and have subscribed to the IoT lab.
To continue, use your favorite browser to access the [RunAbove console](https://api.runabove.com/console/).
                    
![console-main-page][1]
 
## What is a solution?
 
A solution is a container for your data and has a set of tokens to manage this data. 
You can separate your data in different solutions or keep it in a single container depending on your need. 
As example, you could create a solution named 'house-temperature' that contains one token per sensor. 
You can also create a solution named 'Cellar' that will contain one token for humidity and temperature respectively.
 
## What is a token?
 
Tokens are used for authentication and authorization. 
They have a write key (used to push data) and a read key (used to retrieve data). 
Each token belong to a specific solution.

# How to create a new solution

Select iot -> 'POST /iot/app'

![console-solution-creation-page][2]

You can enter the name, description and cluster of your new solution.

  * cluster: The cluster is the location where your data is stored, 
  you can retrieve a list of each available cluster using the GET /iot/availableCluster section, 
  please note that you cannot change the cluster after creation.
  * description: the description you want to assign to your solution.
  * name: the name you want to assign to your new solution. It can contain letters, numbers and dash '-' characters only

Click on the "Execute" button to create your new solution.

# How to modify a solution

Select iot -> 'PUT /iot/app/{app}'

![token-creation-page][3]

  * app: the name of the solution you want to update.
  * cluster: you cannot modify the cluster so ignore this field.
  * description: the new description of the solution.

Select the "Execute" button to modify your solution.

# How to delete a solution

First use your favorite browser to access the [RunAbove console](https://api.runabove.com/console/).

![console-main-page][1]

Select iot -> 'DELETE /iot/app/{app}'

![solution-delete-page][4]

Enter the name of the solution you want to delete.

Select the "Execute" button to modify your solution.

# How to create a new token

Select iot -> 'POST /iot/app/{app}'

![console-token-new-page][5]

  * App: the solution name which will reside the token.
  * description: the description of the token.
  * endDate: endDate format is a unix timestamp based on seconds since standard epoch of 01/01/1970.
  * tagList: the tags of your token.

Select "Execute"

# How to modify a token

Select iot -> 'PUT /iot/app/{app}/token/{token}'

![console-modify-token-page][6]

You cannot modify the expiration date so you must enter the actual unix timestamp of the token in the endDate section.

  * App: the solution name which reside the token.
  * token: the name of the token you want to modify.
  * description: the description of the token.
  * endDate: You cannot modify the endDate of a token so ignore this field.
  * tagList: the tags of your token. If you don't enter old tags they will be dropped during the update.
  
# How to delete a token

Select iot -> 'DELETE /iot/app/{app}/token/{token}'

![solution-delete-page][7]

  * App: the solution name which reside the token.
  * token: the name of the token you want to delete.

Select the "Execute" button to permanently delete your token.

# How to retrieve my tokens

Select the iot section.
Select the 'GET /iot/app/{app}/token' section.
Enter the name of the solution you want to get tokens.

Select "Execute".

The tokens will be displayed in the above section in json.

  [1]: /kb/images/2015-08-10-how-to-manage-solutions-using-runabove-console/main-page.png
  [2]: /kb/images/2015-08-10-how-to-manage-solutions-using-runabove-console/solution-creation-page.png
  [3]: /kb/images/2015-08-10-how-to-manage-solutions-using-runabove-console/solution-modification-page.png
  [4]: /kb/images/2015-08-10-how-to-manage-solutions-using-runabove-console/solution-remove-page.png
  [5]: /kb/images/2015-08-10-how-to-manage-solutions-using-runabove-console/token-creation-page.png
  [6]: /kb/images/2015-08-10-how-to-manage-solutions-using-runabove-console/token-modification-page.png
  [7]: /kb/images/2015-08-10-how-to-manage-solutions-using-runabove-console/token-remove-page.png
