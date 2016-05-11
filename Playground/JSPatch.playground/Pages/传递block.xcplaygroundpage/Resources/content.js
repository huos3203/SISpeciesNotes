// JS
require('JPObject').request(block("NSString *, BOOL", function(ctn, succ) {
                                  console.log('------')
                                  if (succ) log(ctn)  //output: I'm content
                                  }))