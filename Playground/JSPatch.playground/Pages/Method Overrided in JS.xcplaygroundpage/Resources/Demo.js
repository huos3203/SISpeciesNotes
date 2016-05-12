require('UIView, UIColor, UILabel')
defineClass('ddddrrviewController', {
                // replace the -genView method
                genView: function() {
                    //在方法名前加 ORIG 即可调用未覆盖前的 OC 原方法:
                    var view = self.ORIGgenView();
                    view.setBackgroundColor(UIColor.greenColor())
                    var label = UILabel.alloc().initWithFrame(view.frame());
                    label.setText("JSPatch");
                    label.setTextAlignment(1);
                    view.addSubview(label);
                    return view;
                }
            });