---
layout: post
title:  "My first tutorial"
categories: ObjectStorage
author: netroby 
lang: en
---

# Golang upload file into Runabove OpenStack Swift Object Storage

I am glad to share you my golang coding experience. today the topic show you how to upload file to OpenStack swift Object storage.

First , this code example depends on github.com/ncw/swift SDK, you can get it via running 
```
go get -u -v github.com/ncw/swift
```

After download it finish, here we go

Create a file named **main.go**

```golang
package main

import (
	"fmt"
	"github.com/ncw/swift"
)

var (
	APIUser   string = "userismyname@gmail.com" //the username
	APIKey    string = "password"  //the login password or api key
	APIAuth   string = "https://auth.runabove.io/v2.0" //Auth api url 
	APITenant string = "84292384324" //Tenat id
	APIRegion string = "SBG-1"  // The region
)

func main() {
	conn := swift.Connection{
		UserName: APIUser,
		ApiKey:   APIKey,
		AuthUrl:  APIAuth,
		Tenant:   APITenant,
		Region:   APIRegion,
	}
	err := conn.Authenticate()
	if err != nil {
		fmt.Println(err)
		return
	}
	containers, err := conn.ContainerNames(nil)
	fmt.Println(containers)
	err = conn.ObjectPutString("netroby", "2015/12/26/test.txt", "am i a string?", "text/plain")
	if err != nil {
		fmt.Println(err)
	}

}
```

Save the edit. then execute **go run main.go**

And if it success, you will see the file upload to your container, in path 2015/12/26/test.txt

 

If you were using runabove service like me, you can read the api url address on https://cloud.runabove.com/horizon/project/access_and_security/

And you may want to know more about ncw/swift sdk , read the code https://github.com/ncw/swift And the document https://godoc.org/github.com/ncw/swift

