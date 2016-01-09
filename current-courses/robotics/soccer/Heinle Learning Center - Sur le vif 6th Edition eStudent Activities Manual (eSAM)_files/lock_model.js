// JavaScript Document

// Freeze radio button and checkboxes in model box.
// Forms shouldn't be used in the model to avoid nested forms in the activity page. 
// ---> The book activity page has the form "quiaForm" wrapped all the elements.
//
// The value of selected radio button and selected check boxes must be set to 1 in html to remain selected all the time,
// the value of other radio buttons and check boxes must be set to other number different than 1.


// Freeze the radio button group and check boxes, use lockIt(btnList)
// btnList = name of the button group
function lockIt(btnList) {

	var btns = document.getElementsByName(btnList);  
	
	for (i = 0; i < btns.length; ++i)
		if (btns[i].value == "1")                
			btns[i].checked = true;            
		else 
			btns[i].checked = false;

}

// Freeze combo box (drop-down menu) in model box, use cb_onChange(this, selectedItem_number)
function cb_onChange(cb, selectedItem_number)
{
	// When onChange event fired, retrieve the initial selected index.
	cb.selectedIndex = selectedItem_number - 1;
}

