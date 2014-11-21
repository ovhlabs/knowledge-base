---
layout: post
title: "Perl module to get storage content "
categories: Object-Storage
author: mmicael1
---
**Introduction**:
-------------
--------------------------------------
This guide will help you to use runabove storage in perl module. 
Once configured, it will get content source from storage
**Prerequisite:**
-------
-------------------------------------------
Install all necessary packages:
	
	DEBIAN / UBUNTU DISTRIBUTION:
	$ apt-get install build-essential
	
	CENTOS DISTRIBUTION
	$ yum install perl-CPAN
	
	PERL MODULES
	$ cpan install LWP Digest::SHA1 JSON Cache::Memcached Date::Parse Getopt::Long
	
	DOWNLOAD RUNABOVE PERL MODULES
	$ wget -O runabove_data.pm https://gist.githubusercontent.com/mmicael1/c31c4e13ec24d8307228/raw/5de12cd4946920783d899e08e16010d4d474197f/gistfile1.txt

**Steps:**
-------------
--------------------------------------
Write a new perl file:

	$ vi runabove.pl
	
Add the following lines:

	#!/usr/bin/perl

	use runabove_data;
	use Getopt::Long;
	
	my $data_name = "";
	GetOptions ("data_name=s"     => \$data_name);
	              
	if ($data_name eq "") {
		print "ERROR: You must set an data name \n";
		exit(2);
	}
	                   
	my $runabove_config = {
		_storage_name 		=> 'xxx',
		_storage_region 	=> 'xxx',
		_application_secret => 'xxx',
		_application_key 	=> 'xxx',
		_consumer_key 		=> 'xxx'
	}; 
	
	my $cache_config = {
		_enabled => 1,
		_servers => ['127.0.0.1:11211',],
		_key 	=> 'runabove.credentials'	
	};
	
	$runabove = new runabove_data($runabove_config, $cache_config);
	if($runabove){
		$data_source = $runabove->GetDataContent($data_name);
		if($data_source){
			print $data_source;
		}else{
			print "ERROR: unable to get data $data_name \n";
			exit(2);
		}
	}else{
		print "ERROR: can't connect to runabove \n";
		exit(2);
}
	

Modify variables $runabove_config with your settings

You can disable memcached caching credentials bay modifying line: ***_enabled => 0,***


Testing:
--------
If you have configured everything correctly, following command should print the content of your data.

    $ perl runabove.pl --data_name=xxx