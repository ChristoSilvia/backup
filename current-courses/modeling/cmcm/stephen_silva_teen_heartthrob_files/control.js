var t;
function minPopup(){
	clearTimeout(t);
	moveMin(document.getElementById("FloatingBanner"),document.getElementById("MaxControl"));
	document.getElementById('divPopupAd').style.clip="rect(0px 300px 250px 265px)";
}

function maxPopup(){
	clearTimeout(t);
	document.getElementById("FloatingBanner").style.display="block";
	//document.getElementById("MinControl").style.display="block";
	moveMinMax(document.getElementById("MinControl"));
	document.getElementById('divPopupAd').style.clip="auto";
}

function closePopup(){
	document.getElementById("divPopupAd").style.display="none";
	clearTimeout(t);
}

window.onload=function(){
	if (detectmob()==false){
		t=setTimeout("minPopup()",30000);
		document.getElementById('MaxControl').style.display='none';
		showHideControl();
	}else{
		document.getElementById('divPopupAd').innerHTML="";
	}
};

function moveMin(FloatingBanner,MaxControl) {
  var left = 0;
  function frame() {
    left+=6;  
    FloatingBanner.style.left = left + 'px'; 
	MaxControl.style.left = left + 'px';
	if (left == 300){
      clearInterval(id);
	  document.getElementById("MinControl").style.right='-30px';
	  //document.getElementById("MinControl").style.display="block";
	  document.getElementById("FloatingBanner").style.display="none";
	  moveMinMin(document.getElementById("MinControl"));
	 } 
  };
  var id = setInterval(frame,1);
};

function moveMinMin(MinControl) {
  var right = -30;
  function frame() {
    right+=1;  
    MinControl.style.right = right + 'px'; 
	if (right == 0){
      clearInterval(id);
	 } 
  };
  var id = setInterval(frame,10);
};

function moveMax(FloatingBanner,MaxControl) {
  var left = 300;
  function frame() {
    left-=6;  
    FloatingBanner.style.left = left + 'px'; 
	MaxControl.style.left = left + 'px';
	if (left == 0){
      clearInterval(id);
	  document.getElementById("MinControl").style.display="none";
	 } 
  };
  var id = setInterval(frame,1);
};

function moveMinMax(MinControl) {
  var right = 0;
  function frame() {
    right-=1;  
    MinControl.style.right = right + 'px'; 
	if (right == -30){
	  moveMax(document.getElementById("FloatingBanner"),document.getElementById("MaxControl"));
      clearInterval(id);
	 } 
  };
  var id = setInterval(frame,10);
};

function showHideControl(){
	document.getElementById('MaxControl').onmouseover=function(){document.getElementById('MaxControl').style.display='block';};
	document.getElementById('MaxControl').onmouseout=function(){document.getElementById('MaxControl').style.display='none';};
	document.getElementById('FloatingBanner').onmouseover=function(){document.getElementById('MaxControl').style.display='block';};
	document.getElementById('FloatingBanner').onmouseout=function(){document.getElementById('MaxControl').style.display='none';};
};

function detectmob() {
	var w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	var h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
   if(h <= 800 && w <= 600) {
     return true;
   } else {
     return false;
   }
};
	