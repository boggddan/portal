!function(t){"function"==typeof define&&define.amd?define(["jquery"],t):t(jQuery)}(function(t){return t.ui=t.ui||{},t.ui.version="1.12.1"}),function(t){"function"==typeof define&&define.amd?define(["jquery","./version"],t):t(jQuery)}(function(t){return function(){function i(t,i,e){return[parseFloat(t[0])*(c.test(t[0])?i/100:1),parseFloat(t[1])*(c.test(t[1])?e/100:1)]}function e(i,e){return parseInt(t.css(i,e),10)||0}function o(i){var e=i[0];return 9===e.nodeType?{width:i.width(),height:i.height(),offset:{top:0,left:0}}:t.isWindow(e)?{width:i.width(),height:i.height(),offset:{top:i.scrollTop(),left:i.scrollLeft()}}:e.preventDefault?{width:0,height:0,offset:{top:e.pageY,left:e.pageX}}:{width:i.outerWidth(),height:i.outerHeight(),offset:i.offset()}}var n,l=Math.max,f=Math.abs,s=/left|center|right/,h=/top|center|bottom/,r=/[\+\-]\d+(\.[\d]+)?%?/,p=/^\w+/,c=/%$/,a=t.fn.position;t.position={scrollbarWidth:function(){if(void 0!==n)return n;var i,e,o=t("<div style='display:block;position:absolute;width:50px;height:50px;overflow:hidden;'><div style='height:100px;width:auto;'></div></div>"),l=o.children()[0];return t("body").append(o),i=l.offsetWidth,o.css("overflow","scroll"),e=l.offsetWidth,i===e&&(e=o[0].clientWidth),o.remove(),n=i-e},getScrollInfo:function(i){var e=i.isWindow||i.isDocument?"":i.element.css("overflow-x"),o=i.isWindow||i.isDocument?"":i.element.css("overflow-y"),n="scroll"===e||"auto"===e&&i.width<i.element[0].scrollWidth,l="scroll"===o||"auto"===o&&i.height<i.element[0].scrollHeight;return{width:l?t.position.scrollbarWidth():0,height:n?t.position.scrollbarWidth():0}},getWithinInfo:function(i){var e=t(i||window),o=t.isWindow(e[0]),n=!!e[0]&&9===e[0].nodeType,l=!o&&!n;return{element:e,isWindow:o,isDocument:n,offset:l?t(i).offset():{left:0,top:0},scrollLeft:e.scrollLeft(),scrollTop:e.scrollTop(),width:e.outerWidth(),height:e.outerHeight()}}},t.fn.position=function(n){if(!n||!n.of)return a.apply(this,arguments);n=t.extend({},n);var c,d,g,u,m,w,W=t(n.of),v=t.position.getWithinInfo(n.within),y=t.position.getScrollInfo(v),H=(n.collision||"flip").split(" "),b={};return w=o(W),W[0].preventDefault&&(n.at="left top"),d=w.width,g=w.height,u=w.offset,m=t.extend({},u),t.each(["my","at"],function(){var t,i,e=(n[this]||"").split(" ");1===e.length&&(e=s.test(e[0])?e.concat(["center"]):h.test(e[0])?["center"].concat(e):["center","center"]),e[0]=s.test(e[0])?e[0]:"center",e[1]=h.test(e[1])?e[1]:"center",t=r.exec(e[0]),i=r.exec(e[1]),b[this]=[t?t[0]:0,i?i[0]:0],n[this]=[p.exec(e[0])[0],p.exec(e[1])[0]]}),1===H.length&&(H[1]=H[0]),"right"===n.at[0]?m.left+=d:"center"===n.at[0]&&(m.left+=d/2),"bottom"===n.at[1]?m.top+=g:"center"===n.at[1]&&(m.top+=g/2),c=i(b.at,d,g),m.left+=c[0],m.top+=c[1],this.each(function(){var o,s,h=t(this),r=h.outerWidth(),p=h.outerHeight(),a=e(this,"marginLeft"),w=e(this,"marginTop"),x=r+a+e(this,"marginRight")+y.width,T=p+w+e(this,"marginBottom")+y.height,L=t.extend({},m),P=i(b.my,h.outerWidth(),h.outerHeight());"right"===n.my[0]?L.left-=r:"center"===n.my[0]&&(L.left-=r/2),"bottom"===n.my[1]?L.top-=p:"center"===n.my[1]&&(L.top-=p/2),L.left+=P[0],L.top+=P[1],o={marginLeft:a,marginTop:w},t.each(["left","top"],function(i,e){t.ui.position[H[i]]&&t.ui.position[H[i]][e](L,{targetWidth:d,targetHeight:g,elemWidth:r,elemHeight:p,collisionPosition:o,collisionWidth:x,collisionHeight:T,offset:[c[0]+P[0],c[1]+P[1]],my:n.my,at:n.at,within:v,elem:h})}),n.using&&(s=function(t){var i=u.left-L.left,e=i+d-r,o=u.top-L.top,s=o+g-p,c={target:{element:W,left:u.left,top:u.top,width:d,height:g},element:{element:h,left:L.left,top:L.top,width:r,height:p},horizontal:e<0?"left":i>0?"right":"center",vertical:s<0?"top":o>0?"bottom":"middle"};d<r&&f(i+e)<d&&(c.horizontal="center"),g<p&&f(o+s)<g&&(c.vertical="middle"),l(f(i),f(e))>l(f(o),f(s))?c.important="horizontal":c.important="vertical",n.using.call(this,t,c)}),h.offset(t.extend(L,{using:s}))})},t.ui.position={fit:{left:function(t,i){var e,o=i.within,n=o.isWindow?o.scrollLeft:o.offset.left,f=o.width,s=t.left-i.collisionPosition.marginLeft,h=n-s,r=s+i.collisionWidth-f-n;i.collisionWidth>f?h>0&&r<=0?(e=t.left+h+i.collisionWidth-f-n,t.left+=h-e):r>0&&h<=0?t.left=n:h>r?t.left=n+f-i.collisionWidth:t.left=n:h>0?t.left+=h:r>0?t.left-=r:t.left=l(t.left-s,t.left)},top:function(t,i){var e,o=i.within,n=o.isWindow?o.scrollTop:o.offset.top,f=i.within.height,s=t.top-i.collisionPosition.marginTop,h=n-s,r=s+i.collisionHeight-f-n;i.collisionHeight>f?h>0&&r<=0?(e=t.top+h+i.collisionHeight-f-n,t.top+=h-e):r>0&&h<=0?t.top=n:h>r?t.top=n+f-i.collisionHeight:t.top=n:h>0?t.top+=h:r>0?t.top-=r:t.top=l(t.top-s,t.top)}},flip:{left:function(t,i){var e,o,n=i.within,l=n.offset.left+n.scrollLeft,s=n.width,h=n.isWindow?n.scrollLeft:n.offset.left,r=t.left-i.collisionPosition.marginLeft,p=r-h,c=r+i.collisionWidth-s-h,a="left"===i.my[0]?-i.elemWidth:"right"===i.my[0]?i.elemWidth:0,d="left"===i.at[0]?i.targetWidth:"right"===i.at[0]?-i.targetWidth:0,g=-2*i.offset[0];p<0?(e=t.left+a+d+g+i.collisionWidth-s-l,(e<0||e<f(p))&&(t.left+=a+d+g)):c>0&&(o=t.left-i.collisionPosition.marginLeft+a+d+g-h,(o>0||f(o)<c)&&(t.left+=a+d+g))},top:function(t,i){var e,o,n=i.within,l=n.offset.top+n.scrollTop,s=n.height,h=n.isWindow?n.scrollTop:n.offset.top,r=t.top-i.collisionPosition.marginTop,p=r-h,c=r+i.collisionHeight-s-h,a="top"===i.my[1],d=a?-i.elemHeight:"bottom"===i.my[1]?i.elemHeight:0,g="top"===i.at[1]?i.targetHeight:"bottom"===i.at[1]?-i.targetHeight:0,u=-2*i.offset[1];p<0?(o=t.top+d+g+u+i.collisionHeight-s-l,(o<0||o<f(p))&&(t.top+=d+g+u)):c>0&&(e=t.top-i.collisionPosition.marginTop+d+g+u-h,(e>0||f(e)<c)&&(t.top+=d+g+u))}},flipfit:{left:function(){t.ui.position.flip.left.apply(this,arguments),t.ui.position.fit.left.apply(this,arguments)},top:function(){t.ui.position.flip.top.apply(this,arguments),t.ui.position.fit.top.apply(this,arguments)}}}}(),t.ui.position});