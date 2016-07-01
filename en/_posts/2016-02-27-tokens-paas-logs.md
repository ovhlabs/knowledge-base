---
layout: post
title:  "Using tokens to query PaaS Logs"
categories: Logs
author: Babacar Diassé
lang: en
---


With PaaS Logs, there are 3 ways to query your logs.
 
 - The [Graylog Web Interface](https://graylog.laas.runabove.com)
 - The [Graylog API](https://laas.runabove.com:12900/api-browser#!/Search/Relative)
 - The [Elasticsearch API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search.html) located at https://laas.runabove.com:9200 against your [alias](/kb/en/logs/using-kibana-with-laas.html#alias). 


So you can pop up a [Kibana](/kb/en/logs/using-kibana-with-laas.html) or a [Grafana](/kb/en/logs/using-grafana-with-laas.html) or even [a terminal Dashboard for Graylog](https://github.com/Graylog2/cli-dashboard). All these accesses are secured by your username and password. But what if you don't want to put your PaaS Logs credentials everywhere? You can just use tokens to access all these endpoints and revoke them anytime you want. This tutorial is here to tell you how.


#1 Generating tokens 

Generating tokens is one API call away. If you have the curl program installed on your OS, you can use the following command: 

```
curl -u ra-logs-XXXXX -XPOST https://laas.runabove.com:12900/users/ra-logs-XXXXX/tokens/name_of_your_token
```
Please replace ra-logs-XXXXX with your own username and replace `name_of_your_token` by the name of your choice. By typing enter, the curl will ask you for the password associated with the account. It will then display your token in a JSON: 

```
{
  "name": "name_of_your_token",
  "token": "kujg9g227qv0123mav3s0q4pra4psqsi5leka6j7lc62qdef58q",
  "last_access": "1970-01-01T00:00:00.000Z"
}
```

If you don't have curl installed on your desktop. you can use some browser extensions to do this API call:
 
 - For Chrome/Chromium, you can use the application [Postman](https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop) 
 - For Firefox, you can use [REST Easy](https://addons.mozilla.org/en-US/firefox/addon/rest-easy/)

  Postman looks like this
  ![Postman](/kb/images/2016-02-27-tokens-paas-logs/postman_1.png)

  And here is Rest Easy 

  ![Postman](/kb/images/2016-02-27-tokens-paas-logs/rest_easy.png)


#2 Using your tokens

Using your token is no different of using your credentials. You just have to replace your username with your token and your password with the word `token`


For example to issue a search against the Graylog API with the token obtained above, you can do the following:

```
curl -u kujg9g227qv0123mav3s0q4pra4psqsi5leka6j7lc62qdef58q:token -XGET https://laas.runabove.com:12900/search/universal/relative?query=*&range=2592000&filter=streams:a123aebc12345623aafd
```

Note that you have to replace the stream value in the filter parameter by the Id of your stream.

To issue a search against the Elasticsearch API, you also use the same credentials. 

```
curl -u kujg9g227qv0123mav3s0q4pra4psqsi5leka6j7lc62qdef58q:token https://laas.runabove.com:9200/my_alias/_search
```

This call will launch a quick search (to retrieve the count and a sample of your documents) against the alias `my_alias`. Replace the alias by the alias you have setup in you PaaS Logs console. 
Note that these credentials are usable in place of your account credentials in Kibana and Grafana (or any tool that support Basic Authentication with Elasticsearch).

The only place you cannot use your token is the Graylog Web Interface. 
So now that you have your tokens, Let's how you can retrieve or delete them. 


#3 Manage your tokens 

##3.1 List your tokens

To list your tokens you can use the following API Call:

```
curl -u kujg9g227qv0123mav3s0q4pra4psqsi5leka6j7lc62qdef58q:token -XGET https://laas.runabove.com:12900/users/ra-logs-XXXXX/tokens
```

As you can see above, We used my token to access my tokens informations, but you can of course use your regular ra-logs-XXXXX credentials. Don't forget to replace ra-logs-XXXXX with your ra-logs account. 

you will have the following output detailing the tokens available and their last accesses. 

```
{
  "tokens": [
    {
      "name": "firstToken",
      "token": "998n18915scjuo4ppheu0bhcdj4u22ke6v9p7kbmb1g3tk42g72",
      "last_access": "2016-07-01T11:40:50.230Z"
    },
    {
      "name": "secondToken",
      "token": "mjarldkn79fml9efrpq2g2in8i902ebtlnjq115bvn9ncpanfoq",
      "last_access": "1970-01-01T00:00:00.000Z"
    }
  ]
}
```

##3.2 Delete your tokens.

To delete your tokens, use the following API Call

```
curl -XDELETE kujg9g227qv0123mav3s0q4pra4psqsi5leka6j7lc62qdef58q:token -XGET https://laas.runabove.com:12900/users/ra-logs-XXXXX/tokens/kujg9g227qv0123mav3s0q4pra4psqsi5leka6j7lc62qdef58q
```

Note that you must use the value of the token and not the name itself. Again you can use your regular credentials to make this call. 


#Getting Help

- Getting Started : [Quick Start](/kb/en/logs/quick-start.html)
- Documentation : [Guides](/kb/en/logs)
- Mailing List : [paas.logs-subscribe@ml.ovh.net](mailto:paas.logs-subscribe@ml.ovh.net)
- Visit our community: [community.runabove.com](https://community.runabove.com)
- Create an account: [PaaS Logs Beta](https://cloud.runabove.com/signup/?launch=paas-logs)

