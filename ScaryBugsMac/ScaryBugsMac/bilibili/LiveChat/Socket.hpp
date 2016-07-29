//
//  Socket.h
//  bilibili
//
//  Created by TYPCN on 2015/5/17.
//  Copyright (c) 2016 TYPCN. All rights reserved.
//

#ifndef __bilibili__Socket__
#define __bilibili__Socket__

#include <stdio.h>
#include <string>
#include <arpa/inet.h>

class tcp_client{
private:
    int sock;
    std::string address;
    int port;
    struct sockaddr_in server;
    std::string rec_address;
    int rec_port;
    void *rec_userdata;
    
public:
    tcp_client();
    bool conn(std::string, int, void *userdata);
    bool send_data(const void *data,int size);
    std::string receive(int);
    void disconnect😈();
};

#endif /* defined(__bilibili__Socket__) */
