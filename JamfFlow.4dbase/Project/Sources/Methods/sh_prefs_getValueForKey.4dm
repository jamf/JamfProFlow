//%attributes = {}
  //sh_prefs_getValueForKey($vs40_requestedKey;$vt_suggestedValue;$vb_ReplaceExistingValue)

C_TEXT:C284($vt_correspondingValue)

$vs40_requestedKey:=$1

If (Count parameters:C259>=2)
	$vt_suggestedValue:=$2
Else 
	$vt_suggestedValue:=""
End if 

If (Count parameters:C259>=3)
	$vb_ReplaceExistingValue:=$3
Else 
	$vb_ReplaceExistingValue:=False:C215
End if 

If (Count parameters:C259=4)
	$vt_ExampleValue:=$4
Else 
	$vt_ExampleValue:=""
End if 

$vb_refreshCacheArray:=False:C215

If ($vb_ReplaceExistingValue)
	  // Force update to new value
	QUERY:C277([KeyValuePairs:4];[KeyValuePairs:4]KeyName:2=$vs40_requestedKey)
	If (Records in selection:C76([KeyValuePairs:4])=0)
		CREATE RECORD:C68([KeyValuePairs:4])
		[KeyValuePairs:4]ID:1:=Sequence number:C244([KeyValuePairs:4])
		[KeyValuePairs:4]KeyName:2:=$vs40_requestedKey
		[KeyValuePairs:4]ExampleValue:4:=$vt_ExampleValue
	End if 
	[KeyValuePairs:4]ValueString:3:=$vt_suggestedValue
	SAVE RECORD:C53([KeyValuePairs:4])
	$vb_refreshCacheArray:=True:C214
Else 
	
	  // They did not ask to replace the existing value. 
	
	  // Does the pref already exist?
	$vl_KeyElementNumber:=Find in array:C230(<>as40_keyValuePairs_Keys;$vs40_requestedKey)
	If ($vl_KeyElementNumber>0)
		  // Yes, return value
		$vt_correspondingValue:=<>as40_keyValuePairs_Values{$vl_KeyElementNumber}
	Else 
		  // The pref record does not yet exist
		CREATE RECORD:C68([KeyValuePairs:4])
		[KeyValuePairs:4]ID:1:=Sequence number:C244([KeyValuePairs:4])
		[KeyValuePairs:4]KeyName:2:=$vs40_requestedKey
		[KeyValuePairs:4]ValueString:3:=$vt_suggestedValue
		[KeyValuePairs:4]ExampleValue:4:=$vt_ExampleValue
		SAVE RECORD:C53([KeyValuePairs:4])
		$vt_correspondingValue:=$vt_suggestedValue
		$vb_refreshCacheArray:=True:C214
	End if 
End if 

If ($vb_refreshCacheArray)
	  // Load keypairs table into an array
	ARRAY TEXT:C222(<>as40_keyValuePairs_Keys;0)
	ARRAY TEXT:C222(<>as40_keyValuePairs_Values;0)
	ALL RECORDS:C47([KeyValuePairs:4])
	ORDER BY:C49([KeyValuePairs:4];[KeyValuePairs:4]KeyName:2)
	SELECTION TO ARRAY:C260([KeyValuePairs:4]KeyName:2;<>as40_keyValuePairs_Keys)
	SELECTION TO ARRAY:C260([KeyValuePairs:4]ValueString:3;<>as40_keyValuePairs_Values)
End if 

$0:=$vt_correspondingValue
