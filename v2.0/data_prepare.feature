@data_prepare
Feature: data_prepare

  Scenario: space
    Given an empty graph
    And having executed:
      """
      DROP SPACE IF EXISTS ddl_space1;
      DROP SPACE IF EXISTS ddl_space2;
      create space ddl_space1(partition_num=1, replica_factor=1,vid_type = FIXED_STRING(30), charset=utf8,collate=utf8_bin);
      create space ddl_space2(partition_num=10, replica_factor=1,vid_type = FIXED_STRING(30), charset=utf8,collate=utf8_bin);
      """
    And wait 6 seconds
    When executing query:
      """
      DESC SPACE ddl_space1
      """
    Then the execution should be successful
    When executing query:
      """
      DESC SPACE ddl_space2
      """
    Then the execution should be successful

  Scenario: tag
    Given an empty graph
    And having executed:
      """
      DROP SPACE IF EXISTS ddl_tag_space1;
      create space ddl_tag_space1(partition_num=1, replica_factor=1,vid_type = FIXED_STRING(30), charset=utf8,collate=utf8_bin);
      use  ddl_tag_space1;
      create tag ddl_tag1(col1 bool , col2 int64, col3 double,col4 float, col5 string) TTL_DURATION = 0,TTL_COL = "col2" ;
      create tag ddl_tag2(col1 FIXED_STRING(30),col2 int8, col3 int16,col4 int32,col5 timestamp) ;
      create tag ddl_tag3(col1 date, col2 datetime, col3 time);
      create tag ddl_tag4(col1 bool default true , col2 int64 default 64, col3 double default 7.2,col4 float default 0.1, col5 string default "111")  TTL_DURATION = 1000000,TTL_COL = "col2" ;
      create tag ddl_tag5(col1 FIXED_STRING(30) default "xxx",col2 int8 default 10, col3 int16 default 16,col4 int32 default 32,col5 timestamp default `timestamp`("2000-10-10T10:00:00"));
      create tag ddl_tag6(col1 date default date("2017-03-04"), col2 datetime default datetime("2017-03-04T00:00:01"),col3 time default time("11:11:11"));
      """
    And wait 6 seconds
    When executing query:
      """
      show tags;
      """
    Then the result should be, in any order:
      | Name       |
      | "ddl_tag1" |
      | "ddl_tag2" |
      | "ddl_tag3" |
      | "ddl_tag4" |
      | "ddl_tag5" |
      | "ddl_tag6" |

  Scenario: edge
    Given an empty graph
    And having executed:
      """
      DROP SPACE IF EXISTS ddl_edge_space1;
      create space ddl_edge_space1(partition_num=1, replica_factor=1,vid_type = FIXED_STRING(30), charset=utf8,collate=utf8_bin);
      use  ddl_edge_space1;
      create edge ddl_edge1(col1 bool , col2 int64, col3 double,col4 float, col5 string) TTL_DURATION = 0,TTL_COL = "col2" ;
      create edge ddl_edge2(col1 FIXED_STRING(30),col2 int8, col3 int16,col4 int32,col5 timestamp);
      create edge ddl_edge3(col1 date, col2 datetime, col3 time);
      create edge ddl_edge4(col1 bool default true , col2 int64 default 64, col3 double default 7.2,col4 float default 0.1, col5 string default "111") TTL_DURATION = 100000,TTL_COL = "col2" ;
      create edge ddl_edge5(col1 FIXED_STRING(30) default "xxx",col2 int8 default 10, col3 int16 default 16,col4 int32 default 32,col5 timestamp default`timestamp`("2000-10-10T10:00:00"));
      """
    And wait 6 seconds
    When executing query:
      """
      show edges;
      """
    Then the result should be, in any order:
      | Name        |
      | "ddl_edge1" |
      | "ddl_edge2" |
      | "ddl_edge3" |
      | "ddl_edge4" |
      | "ddl_edge5" |

  Scenario: user
    Given an empty graph
    And having executed:
      """
      drop user if exists user1;
      drop user if exists user2;
      drop user if exists user3;
      drop space if exists user_space1;
      drop space if exists user_space2;
      drop space if exists user_space3;
      
      CREATE USER user1 WITH PASSWORD "nebula";
      CREATE USER user2 WITH PASSWORD "nebula";
      CREATE USER user3 WITH PASSWORD "nebula";
      create space user_space1;
      create space user_space2;
      create space user_space3;
      """
    And wait 6 seconds
    When executing query:
      """
      grant DBA ON user_space1 TO user1;
      grant USER ON user_space2 TO user2;
      grant GUEST ON user_space3 TO user3;
      show users;
      """
    Then the result should be, in any order:
      | Account |
      | "user1" |
      | "user3" |
      | "root"  |
      | "user2" |

  Scenario: storage_vertex
    Given an empty graph
    And having executed:
      """
      DROP SPACE IF EXISTS storage_vertex_space1;
      create space storage_vertex_space1(partition_num=1, replica_factor=1,vid_type = FIXED_STRING(30), charset=utf8,collate=utf8_bin);
      use storage_vertex_space1;
      create tag storage_tag1(col1 bool , col2 int64, col3 double,col4 float, col5 string);
      create tag storage_tag2(col1 FIXED_STRING(30),col2 int8, col3 int16,col4 int32,col5 timestamp) ;
      create tag storage_tag3(col1 date, col2 datetime, col3 time);
      create tag storage_tag4(col1 bool default true , col2 int64 default 64, col3 double default 7.2,col4 float default 0.1, col5 string default "111") ;
      create tag storage_tag5(col1 FIXED_STRING(30) default "xxx",col2 int8 default 10, col3 int16 default 16,col4 int32 default 32,col5 timestamp default 0);
      create tag storage_tag6(col1 date default date("2017-03-04"),col2 datetime default datetime("2017-03-04T00:00:01"),col3 time default time("11:11:11"));
      """
    And wait 6 seconds
    When executing query:
      """
      insert vertex storage_tag1(col1,col2,col3,col4,col5) Values "1":(true,9223372036854775807,99999999.111111,888888.111111,"");
      insert vertex storage_tag1(col1,col2,col3,col4,col5) Values "2":(false,-9223372036854775808,-99999999.111111,-888888.1111,"aaa");
      insert vertex storage_tag1(col1,col2,col3,col4,col5) Values "3":(true,100,1.1,9.9999,"xsaxasx");
      insert vertex storage_tag1(col1,col2,col3,col4,col5) Values "4":(NULL,NULL,NULL,NULL,NULL);
      insert vertex storage_tag2(col1,col2,col3,col4,col5) Values "1":("",127,32767,2147483647,0);
      insert vertex storage_tag2(col1,col2,col3,col4,col5) Values "2":("aaa",-127,-32767,-2147483647,20);
      insert vertex storage_tag2(col1,col2,col3,col4,col5) Values "3":(NULL,NULL,NULL,NULL,1);
      insert vertex storage_tag3(col1, col2, col3) Values "1":(date("0001-01-01"),datetime("0001-01-01T00:00:00"),time("00:00:00"));
      insert vertex storage_tag3(col1, col2, col3) Values "2":(date("2030-01-01"),datetime("2030-01-01T23:59:59"),time("23:59:59"));
      insert vertex storage_tag3(col1, col2, col3) Values "3":(date("2020-01-01"),datetime("2020-01-01T01:11:59"),time("12:11:59"));
      insert vertex storage_tag4() Values "1":();
      insert vertex storage_tag5() Values "4":();
      insert vertex storage_tag6() Values "6":();
      """
    Then the execution should be successful

  Scenario: storage_edge
    Given an empty graph
    And having executed:
      """
      DROP SPACE IF EXISTS storage_edge_space1;
      create space storage_edge_space1(partition_num=1, replica_factor=1,vid_type = FIXED_STRING(30), charset=utf8,collate=utf8_bin);
      use storage_edge_space1;
      create edge storage_edge1(col1 bool , col2 int64, col3 double,col4 float, col5 string);
      create edge storage_edge2(col1 FIXED_STRING(30),col2 int8, col3 int16,col4 int32,col5 timestamp) ;
      create edge storage_edge3(col1 date, col2 datetime, col3 time);
      create edge storage_edge4(col1 bool default true , col2 int64 default 64, col3 double default 7.2,col4 float default 0.1, col5 string default "111") ;
      create edge storage_edge5(col1 FIXED_STRING(30) default "xxx",col2 int8 default 10, col3 int16 default 16,col4 int32 default 32,col5 timestamp default 0);
      """
    And wait 12 seconds
    When executing query:
      """
      insert edge storage_edge1(col1,col2,col3,col4,col5) Values "1"->"2":(true,9223372036854775807,99999999.111111,888888.111111,"");
      insert edge storage_edge1(col1,col2,col3,col4,col5) Values "1"->"3":(false,-9223372036854775808,-99999999.111111,-888888.1111,"aaa");
      insert edge storage_edge1(col1,col2,col3,col4,col5) Values "1"->"4":(true,100,1.1,9.9999,"xsaxasx");
      insert edge storage_edge1(col1,col2,col3,col4,col5) Values "1"->"5":(NULL,NULL,NULL,NULL,NULL);
      insert edge storage_edge2(col1,col2,col3,col4,col5) Values "1"->"2":("",127,32767,2147483647,0);
      insert edge storage_edge2(col1,col2,col3,col4,col5) Values "1"->"3":("aaa",-127,-32767,-2147483647,20);
      insert edge storage_edge2(col1,col2,col3,col4,col5) Values "1"->"4":(NULL,NULL,NULL,NULL,1);
      insert edge storage_edge3(col1,col2,col3) Values "1"->"2":(date("0001-01-01"),datetime("0001-01-01T00:00:00"),time("00:00:00"));
      insert edge storage_edge3(col1,col2,col3) Values "1"->"3":(date("2030-01-01"),datetime("2030-01-01T23:59:59"),time("23:59:59"));
      insert edge storage_edge3(col1,col2,col3) Values "1"->"4":(date("2020-01-01"),datetime("2020-01-01T01:11:59"),time("12:11:59"));
      insert edge storage_edge4() Values "1"->"2":();
      insert edge storage_edge5() Values "1"->"2":();
      """
    Then the execution should be successful

  Scenario: storage_tag_index
    Given an empty graph
    And having executed:
      """
      DROP SPACE IF EXISTS storage_tag_index_space1;
      create space storage_tag_index_space1(partition_num=1, replica_factor=1,vid_type = FIXED_STRING(30), charset=utf8,collate=utf8_bin);
      use storage_tag_index_space1;
      create tag tag1(col1 int,col2 double,col3 string);
      create tag tag2(col1 int,col2 double,col3 string);
      """
    And wait 6 seconds
    When executing query:
      """
      create tag index tag1_index1 on tag1(col1);
      create tag index tag1_index2 on tag1(col2);
      create tag index tag1_index3 on tag1(col3(30));
      create tag index tag2_index1 on tag2(col1,col2);
      create tag index tag2_index2 on tag2(col1,col3(30));
      create tag index tag2_index3 on tag2(col1,col2,col3(30));
      """
    And wait 6 seconds
    Then the execution should be successful
    When executing query:
      """
      insert vertex tag1(col1,col2,col3)  Values "1":(1,1.1,"aaa");
      insert vertex tag1(col1,col2,col3)  Values "2":(2,2.2,"bbb");
      insert vertex tag2(col1,col2,col3)  Values "1":(1,1.1,"aaa");
      insert vertex tag2(col1,col2,col3)  Values "2":(2,2.2,"bbb");
      """
    Then the execution should be successful

  Scenario: storage_edge_index
    Given an empty graph
    And having executed:
      """
      DROP SPACE IF EXISTS storage_edge_index_space1;
      create space storage_edge_index_space1(partition_num=1, replica_factor=1,vid_type = FIXED_STRING(30), charset=utf8,collate=utf8_bin);
      use storage_edge_index_space1;
      create edge edge1(col1 int,col2 double,col3 string);
      create edge edge2(col1 int,col2 double,col3 string);
      """
    And wait 6 seconds
    When executing query:
      """
      create edge index edge1_index1 on edge1(col1);
      create edge index edge1_index2 on edge1(col2);
      create edge index edge1_index3 on edge1(col3(30));
      create edge index edge2_index1 on edge2(col1,col2);
      create edge index edge2_index2 on edge2(col1,col3(30));
      create edge index edge2_index3 on edge2(col1,col2,col3(30));
      """
    And wait 6 seconds
    Then the execution should be successful
    When executing query:
      """
      insert edge edge1(col1,col2,col3)  Values "1"->"2":(1,1.1,"aaa");
      insert edge edge1(col1,col2,col3)  Values "1"->"3":(2,2.2,"bbb");
      insert edge edge2(col1,col2,col3)  Values "1"->"2":(1,1.1,"aaa");
      insert edge edge2(col1,col2,col3)  Values "1"->"3":(2,2.2,"bbb");
      insert edge edge2(col1,col2,col3)  Values "1"->"2"@1:(1,1.1,"aaa");
      insert edge edge2(col1,col2,col3)  Values "1"->"3"@1:(2,2.2,"bbb");
      """
    Then the execution should be successful

  Scenario: storage_modify
    Given an empty graph
    And having executed:
      """
      
      DROP SPACE IF EXISTS storage_modify_space1;
      create space storage_modify_space1(partition_num=1, replica_factor=1,vid_type = FIXED_STRING(30), charset=utf8,collate=utf8_bin);
      use storage_modify_space1;
      create tag tag1(col1 int,col2 double,col3 string);
      create tag tag2(col1 int,col2 double,col3 string);
      create tag tag3(col1 int,col2 double,col3 string);
      create edge edge1(col1 int,col2 double,col3 string);
      create edge edge2(col1 int,col2 double,col3 string);
      create edge edge3(col1 int,col2 double,col3 string);
      """
    And wait 6 seconds
    When executing query:
      """
      insert vertex tag1(col1,col2,col3) values "1":(1,1.1,"aaa");
      insert vertex tag1(col1,col2,col3) values "2":(2,2.2,"bbb");
      insert vertex tag2(col1,col2,col3) values "1":(1,1.1,"aaa");
      insert vertex tag2(col1,col2,col3) values "2":(2,2.2,"bbb");
      insert vertex tag3(col1,col2,col3) values "1":(1,1.1,"aaa");
      insert vertex tag3(col1,col2,col3) values "2":(2,2.2,"bbb");
      insert edge edge1(col1,col2,col3)  Values "1"->"2":(1,1.1,"aaa");
      insert edge edge1(col1,col2,col3)  Values "1"->"3":(2,2.2,"bbb");
      insert edge edge2(col1,col2,col3)  Values "1"->"2":(1,1.1,"aaa");
      insert edge edge2(col1,col2,col3)  Values "1"->"3":(2,2.2,"bbb");
      insert edge edge3(col1,col2,col3)  Values "1"->"2":(1,1.1,"aaa");
      insert edge edge3(col1,col2,col3)  Values "1"->"3":(2,2.2,"bbb");
      insert edge edge3(col1,col2,col3)  Values "1"->"3":(2,2.2,"bbb");
      insert edge edge3(col1,col2,col3)  Values "1"->"3":(2,2.2,"bbb");
      """
    And wait 12 seconds
    Then the execution should be successful
    When executing query:
      """
      alter tag tag1 add (col4 timestamp);
      alter tag tag2 drop (col3);
      alter tag tag3 change (col1 double);
      alter edge edge1 add (col4 timestamp);
      alter edge edge2 drop (col3);
      alter edge edge3 change (col1 double);
      """
    And wait 12 seconds
    Then the execution should be successful
    When executing query:
      """
      insert vertex tag1(col1,col2,col3,col4) values "3":(3,3.3,"ccc",0);
      insert vertex tag1(col1,col2,col3,col4) values "4":(4,4.4,"ddd",0);
      insert vertex tag2(col1,col2) values "3":(3,3.3);
      insert vertex tag2(col1,col2) values "4":(4,4.4);
      insert vertex tag3(col1,col2,col3) values "3":(3.1,4.4,"ccc");
      insert vertex tag3(col1,col2,col3) values "4":(4.1,4.4,"ddd");
      insert edge edge1(col1,col2,col3,col4) values "1"->"3":(3,3.3,"ccc",0);
      insert edge edge1(col1,col2,col3,col4) values "1"->"4":(4,4.4,"ddd",0);
      insert edge edge2(col1,col2) values "1"->"3":(3,3.3);
      insert edge edge2(col1,col2) values "1"->"4":(4,4.4);
      insert edge edge3(col1,col2,col3) values "1"->"3":(3.1,3.3,"ccc");
      insert edge edge3(col1,col2,col3) values "1"->"4":(4.1,4.4,"ddd");
      """
    And wait 6 seconds
    Then the execution should be successful
