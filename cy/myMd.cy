// (function(utils) {

//     utils.constants = {
//         APPID:  	 NSBundle.mainBundle.bundleIdentifier,
//         APPPATH:     NSBundle.mainBundle.bundlePath,
//         APPHOME:	 NSHomeDirectory(),
//         APPDOC:      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0],
//         APPLIBRARY:  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0],
//         APPCACHE:    NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
//     };

//     utils.pviews = function(){
//         return UIApp.keyWindow.recursiveDescription().toString();
//     };

//     utils.pvcs = function(){
//         return UIWindow.keyWindow().rootViewController._printHierarchy().toString();
//     };

//     utils.rp = function(target){
//         var result = "" + target.toString();
//         while(target.nextResponder){
//             result += "\n" + target.nextResponder.toString();
//             target = target.nextResponder;
//         }
//         return result;
//     };

//     utils.loadFramework = function (target) { 
//         var h="/System/Library/",t="Frameworks/"+target+".framework";
//         return [[NSBundle bundleWithPath:h+t]||
//         [NSBundle bundleWithPath:h+"Private"+t] load];
//     }


//     utils.tryPrintIvars = function tryPrintIvars(a){ var x={}; for(i in *a){ try{ x[i] = (*a)[i]; } catch(e){} } return x; }


//     utils.printMethods = function printMethods(className, isa) { 
//         var count = new new Type("I");
//         var classObj = (isa != undefined) ? objc_getClass(className)->isa :     
//         objc_getClass(className); 
//         var methods = class_copyMethodList(classObj, count); 
//         var methodsArray = [];
//         for(var i = 0; i < *count; i++) { 
//             var method = methods[i]; 
//             methodsArray.push({selector:method_getName(method),     
//             implementation:method_getImplementation(method)});
//     }
//         free(methods); 
//         return methodsArray;
// }




//     utils.pactions = function(target){
// 		var result = '';
// 		var objs = target.allTargets.allObjects();
// 		for(var i = 0; i < objs.length; i++){
// 			var actions = [target actionsForTarget:objs[i] forControlEvent:0];
// 			result += objs[i] + " " + [actions componentsJoinedByString:@","];
// 		}
// 		return result;
// 	}

//     for(var k in utils.constants) {
//         Cycript.all[k] = utils.constants[k];
//     }

//     for(var k in utils) {
//         if(utils.hasOwnProperty(k)) {
//             var f = utils[k];
//             if(typeof f === 'function') {
//                 Cycript.all[k] = f;
//             }
//         }
//     }
// })(exports);


function pviews(){
        return UIWindow.keyWindow().rootViewController._printHierarchy().toString();
    };