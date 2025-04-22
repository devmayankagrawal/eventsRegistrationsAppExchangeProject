import { LightningElement,track,wire,api } from 'lwc';
import IMAGE from '@salesforce/resourceUrl/ThutechLogo';

import ImageFirstPage from '@salesforce/resourceUrl/FirstPageImage';
//import ImageSecondPage from '@salesforce/resourceUrl/SecondPageImage';


import Event_Registration_Form_URL from '@salesforce/label/c.Event_Registration_Form_URL';
import googleUrl from '@salesforce/label/c.googleUrl';

import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import EVENT_OBJECT from '@salesforce/schema/Events__c';  // Replace with the relevant object
//import EVENT_LANGUAGE_FIELD from '@salesforce/schema/Events__c.Event_Language__c'; // Replace with your custom picklist field

import CONTACT_OBJECT from '@salesforce/schema/Contact';
import gender from '@salesforce/schema/Contact.Gender__c';
import country from '@salesforce/schema/Contact.Country__c';

import fetchEventsAndSessions from '@salesforce/apex/EventRegistrationClass.fetchEventsAndSessions';
import selectedEvents from '@salesforce/apex/EventRegistrationClass.selectedEvents';
import showAttendeeRecords from '@salesforce/apex/EventRegistrationClass.showAttendeeRecords';


import newEventRegitsrtaionRecord from '@salesforce/apex/EventRegistrationClass.newEventRegitsrtaionRecord';
import statusUpdateMethod from '@salesforce/apex/EventRegistrationClass.statusUpdateMethod';
import selectedEventsInDashBoard from '@salesforce/apex/EventRegistrationClass.selectedEventsInDashBoard';
import ShowSessionFirstPageDashboard from '@salesforce/apex/EventRegistrationClass.ShowSessionFirstPageDashboard';
import getUpcommingSessions from '@salesforce/apex/EventRegistrationClass.getUpcommingSessions';
import getPastSessions from '@salesforce/apex/EventRegistrationClass.getPastSessions';
import handleWinDrawlled from '@salesforce/apex/EventRegistrationClass.handleWinDrawlled';

import createContacts from '@salesforce/apex/EventRegistrationClass.createContacts';

import Id from '@salesforce/user/Id';
import UserNameFIELD from '@salesforce/schema/User.Name';
import {
	getRecord
} from 'lightning/uiRecordApi';

import LightningAlert from "lightning/alert";

export default class EventRegistrationComponent extends LightningElement {

	@track objContact = {
		'sobjectType': 'Contact'
	};
	@track contactObject = {
		'sobjectType': 'Contact',
		OrgEventManager__Consent_Checkbox__c: false
	};

    @track imageUrl = IMAGE;
    @track FirstPage = true;
	//@track SecondPage = false;
	@track ThirdPage = false;
	@track FourthPage = false;
	@track FifthPage = false;
	@track SixthPage = false;
	@track SeventhPage = false;
	@track NinthPage = false;    
	

	@track ImageFirstPage = ImageFirstPage;
	//@track ImageSecondPage = ImageSecondPage;


    //@track showmsg = false;

    handleGetStarted() {
		this.FirstPage = false;
		//this.SecondPage = true;
		this.FourthPage = true;
		this.FifthPage = false;
		this.SixthPage = false;
		this.SeventhPage = false;
		this.NinthPage = false;
		window.scrollTo(0, 0);
		this.handleSubmitButton();
	}

    buttonStyle = 'background-color: gray; color: white;';

	/*@track selectedLanguages = [];
    @track languages = [];

    @wire(getPicklistValues, { recordTypeId: '$eventInfo.data.defaultRecordTypeId', fieldApiName: EVENT_LANGUAGE_FIELD })
    languagePicklist({ data, error }) {
        if (data) {
            // Mapping picklist values to array of {label, value}
            this.languages = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));
        } else if (error) {
            this.error = error;
            console.log('Error fetching language picklist values: ', error);
        }
    }*/


     // Handle button click for selecting languages
	 /*handleButtonClick(event) {
        const language = event.target.dataset.lang;
        console.log('language======>' + language);

        if (this.selectedLanguages.includes(language)) {
            // If selected, remove it from the selectedLanguages array
            this.selectedLanguages = this.selectedLanguages.filter(lang => lang !== language);
        } else {
            // If not selected, add it to the selectedLanguages array
            this.selectedLanguages = [...this.selectedLanguages, language];
        }

        // Log the selected languages to the console
        console.log("Selected Languages:", JSON.stringify(this.selectedLanguages));

        // Convert the selectedLanguages array to a string for further processing
        const selectedLanguagesString = this.selectedLanguages.join(';');
        console.log("Selected Languages String:", selectedLanguagesString);

        this.updateButtonColor();
    }

    // Update button styles based on selection
    updateButtonColor() {
        const buttons = this.template.querySelectorAll('button[data-name="language"]');
        buttons.forEach(button => {
            const language = button.dataset.lang;
            const isSelected = this.selectedLanguages.includes(language);
            button.style.backgroundColor = isSelected ? '#00BFFF' : ''; // Change background color
            button.style.color = '#50276B'; // Set text color
        });
    }*/

    /*handleBack01() {
		this.FirstPage = true;
		//this.SecondPage = false;
		this.FourthPage = false;
		this.FifthPage = false;
		this.SixthPage = false;
		this.SeventhPage = false;
		this.NinthPage = false;
		window.scrollTo(0, 0);
	}*/

    /*handleContinue() {
		window.scrollTo(0, 0);

		if(this.selectedLanguages.length>0){
			
			window.scrollTo(0, 0);
		this.FirstPage = false;
		this.SecondPage = false;
		this.FourthPage = true;
		this.FifthPage = false;
		this.SixthPage = false;
		this.SeventhPage = false;
		this.NinthPage = false;
		this.handleSubmitButton();
		}else{
			
			window.scrollTo(0, 0);
		this.FirstPage = false;
		this.SecondPage = true;
		this.FourthPage = false;
		this.FifthPage = false;
		this.SixthPage = false;
		this.SeventhPage = false;
		this.NinthPage = false;
		this.showmsg = true;		
		}
	}*/

    renderedCallback() {

		/*if (this.ThirdPage && this.CSGOpen) {
			console.log('radio button selected');
			this.selectedIDS = [];
		}*/

		if (this.Allsessions.length > 0) {

			this.Allsessions.forEach(e => {
				let sessionList = this.template.querySelector(`.session-checkbox[data-event-id="${e}"]`);
				if (sessionList) {
					sessionList.checked = true;
					//console.log('sessionList checked=====>' + sessionList.checked);
				}
			});

			if (this.selectedIDS.length > 0) {

				this.selectedIDS.forEach(e => {
					let sessionList = this.template.querySelector(`[data-event-id="${e}"]`);
					if (sessionList) {
						sessionList.checked = true;
					}
				});

			}


		}

        /*if (!this.FirstPage) {
			console.log('renderedCallback call======>');
			console.log("Selected Languages=========>", JSON.stringify(this.selectedLanguages));
			//this.updateButtonColorForProgrammes();
			if (this.selectedLanguages.length > 0) {
				this.updateButtonColor();
			}
		}*/

		
		if (this.activeSections.length > 0) {
            const accordion = this.template.querySelector('lightning-accordion');
            if (accordion) {
                accordion.activeSectionName = this.activeSections;
            }
        }

		const checkbox = this.template.querySelector('.CheckfieldClass');
		if (checkbox) {
			checkbox.checked = this.contactObject.OrgEventManager__Consent_Checkbox__c;
		}

		/*const styleTag = document.createElement('style');
            styleTag.innerText = `c-event-registration-component .CheckfieldClass .slds-checkbox .slds-checkbox__label .slds-form-element__label
        {   
            font-family: Arial;
            font-size: 17px;
            line-height: 17px;
            letter-spacing: 0em;
            text-align: left;
			line-height: 1.5em;
        }`
		
		if (!this.template.querySelector('style')) {
            this.template.appendChild(styleTag);			
        }*/

			 // Check if styles have already been injected
			 if (!this.styleInjected) {
				const styleTag = document.createElement('style');
				styleTag.innerText = `
					/* Styles for your CheckfieldClass */
					c-event-registration-component .CheckfieldClass .slds-checkbox .slds-checkbox__label .slds-form-element__label {   
						font-family: Arial;
						font-size: 17px;
						line-height: 1.5em;
						letter-spacing: 0em;
						text-align: left;
					}
	
					/* Styles for Accordion */
					@media (min-width: 64em) {
					.custom-accordion .slds-accordion__summary-content {
							max-width: 100%;
							overflow: hidden;
							text-overflow: ellipsis;
							font-size: 20px !important;
							font-family: Arial;
							white-space: nowrap;
						}
					}
				`;
	
				// Append styles to the LWC's root template
				this.template.appendChild(styleTag);
				this.styleInjected = true; // Mark as injected
			}
		

		// Ensure that checkboxes are checked based on cgContactIds
		this.showPreviousCgContacts.forEach(contact => {
			const checkbox = this.template.querySelector(`lightning-input[data-event-id="${contact.Id}"]`);
			if (checkbox) {
				checkbox.checked = this.cgContactIds.includes(contact.Id);
			}
		});		
    }

	

	
    // Get object metadata to fetch default record type ID
    @wire(getObjectInfo, { objectApiName: EVENT_OBJECT })
    eventInfo;

    
	@track activeSections = [];
	@api groupData = []; // new groupdata array created.
	handleSubmitButton() {
		console.log("handle submit button");

		//const selectedLanguagesString = this.selectedLanguages.join(';');
		//const selectedprogram = this.selectedProgrammes.join(';');
		//console.log('selectedLanguages=======>', JSON.stringify(this.selectedLanguages));
		//console.log('selectedProgrammes=======>', JSON.stringify(this.selectedProgrammes));

		//console.log("Selected Languages=======", selectedLanguagesString);
		//console.log("Selected selectedprogram=======", selectedprogram);

		var eventType = [];

		eventType.push(this.CSGOpen);
		this.storeEventType = eventType[0];
		console.log('storeEventType========>', this.storeEventType);

		fetchEventsAndSessions({
				
			})

			.then((result) => {

				this.events = result.events.filter(event => event.OrgEventManager__Event_State__c === 'Active').map(event => {

					const modifiedEvent = {
						...event
					};
					this.activeSections.push(event.Id);
					console.log('-----------' + event.Id);					

					let totalWaitlistedCG = 0;
					let totalRegisteredCG = 0;
					let sessionCount = 0;
					let cnt = 0;
					let regcontct = 0;
					if (event.OrgEventManager__Sessions__r) {
						event.OrgEventManager__Sessions__r.forEach(session => {
							console.log('Total Waitlisted CG:', session.OrgEventManager__Total_Waitlisted_Attendee__c);
							console.log('Total Registered CG:', session.OrgEventManager__Total_Registered_Attendee__c);
							totalWaitlistedCG += session.OrgEventManager__Total_Waitlisted_Attendee__c;
							totalRegisteredCG += session.OrgEventManager__Total_Registered_Attendee__c;
							sessionCount = totalWaitlistedCG + totalRegisteredCG;
							cnt++;


						});
						//regcontct = sessionCount/ cnt;
						console.log('regcontct', sessionCount / cnt);
					} else {
						console.log('No sessions found for this event.');
					}

					regcontct = sessionCount / cnt;
					console.log('0000000', regcontct);


					if (!modifiedEvent.OrgEventManager__Sessions__r || modifiedEvent.OrgEventManager__Sessions__r.length === 0) {
						modifiedEvent.hasNoSessions = true;
						//modifiedEvent.Event_Evaluation__c = event.Event_Evaluation__c;
						//console.log('modifiedEvent.Event_Evaluation__c=====>' + JSON.stringify(modifiedEvent.Event_Evaluation__c));

					} else {
						// Modify the Event_Language__c field if sessions are present
						modifiedEvent.hasNoSessions = false;
						modifiedEvent.OrgEventManager__Event_Language__c = event.OrgEventManager__Event_Language__c.split(';').map(language => language.trim()).join(', ');
					}


					let totalvacancy = 0;
					if (modifiedEvent.OrgEventManager__Sessions__r) {
						modifiedEvent.OrgEventManager__Sessions__r.forEach(session => {
							totalvacancy += event.OrgEventManager__Sessions__r.OrgEventManager__Total_Waitlisted_Attendee__c;
							if (session.OrgEventManager__Events__r && session.OrgEventManager__Events__r.OrgEventManager__Waiting_List__c) {
								totalvacancy += session.OrgEventManager__Events__r.OrgEventManager__Waiting_List__c;
								console.log(totalvacancy);
							}
						});
					}

					console.log("count as per event", totalvacancy);
					console.log("event.Capacity__c", event.OrgEventManager__Capacity__c);
					console.log("event.Waitlist_Number_Capacity__c", event.OrgEventManager__Waitlist_Number_Capacity__c);
					let et = event.OrgEventManager__Capacity__c;
					let wt = event.OrgEventManager__Waitlist_Number_Capacity__c;
					let total = wt + et;
					console.log("ppppp", total);


					if (et <= regcontct && regcontct < total) {
						modifiedEvent.capacityMessage = "Note: Event is fully subscribed. You may register to be in the waitlist.";
						console.log("Event is fully subscribed. You may register to be in the waitlist.");
						modifiedEvent.registrationClosed = true; // Event is not full
						// capacityChecked = true;

					} else if (regcontct >= (et + wt)) {
						modifiedEvent.capacityMessage = "Note: Event is fully subscribed.";
						modifiedEvent.registrationClosed = true; // Event is full
						console.log("Event is fully subscribed.");
						modifiedEvent.hideCheckboxsession = true;
					} else {
						console.log("welcome");
					}
					
					return modifiedEvent;
				});
				//this.events = result.events; 

				console.log('Getting eeeeeeeeeeeee=====>' + JSON.stringify(this.activeSections));

				console.log('Getting Event records=====>' + JSON.stringify(this.events));
				console.log('Updated ---' + JSON.stringify(this.events));
				this.updateUI(this.events);
				this.modifyeventHandler(this.events);
				// this.events = this.handleCapcity(this.events);
				// console.log("final data updated+++====" , this.events);
				//////////////////////
				this.events.forEach(ele => {

				});
			
			})

			.catch((error) => {
				this.error = error;
			});
		window.scrollTo(0, 0);
	}

	updateUI(events) {
		events.forEach(event => {
			// Render the event in the UI
			// For illustration purposes, logging the event
			console.log('Event:', JSON.stringify(event));
			// Check for the flag and display a message if there are no sessions
			if (event.hasNoSessions) {
				console.log('This event has no sessions and has been populated with default fields.');
			}
		});
	}

	modifyeventHandler(data) // new method created by modify event array.
	{
		const groupedData = {};
		data.forEach(item => {
			const groupName = item.OrgEventManager__Event_Programmes__c;
			if (!groupedData[groupName]) {
				groupedData[groupName] = {
					groupName: groupName,
					list: []
				};
			}
			groupedData[groupName].list.push(item);
		});
		this.groupData = Object.values(groupedData);
		console.log('modifyeventHandler=========', JSON.stringify(this.groupData));
	}

	@track hideCheckboxsession = false;
	@track registrationClosed = false;
	@track registrationMessage = '';
	@track capacityMessage = '';

	@track selectedEvent = [];
	@track Allsessions = [];
	@track showEvents;
	@track InDashBoard;
	
	@track eventCheckboxChecked = false;
	@track sessionCheckboxChecked = false;
	@track selectedIDS = [];
	@track checkEvent = false;
	@track isActive = false;
	@track getallsesssion = [];
	@track eachsession;
	EventData = [];
	formInput = {};
	checked1 = false;
	selectedvalue = false;

	handleEventSelection(event) {
		const selectedEventLabel = event.target.label;
		const selectedEventId1 = event.currentTarget.dataset.eventId;
		let ParentID = event.target.name;
		console.log('ParentID=======>' + ParentID);
		console.log('selectedEventLabel=======>' + selectedEventLabel);
		console.log('selectedEventId1=======>' + selectedEventId1);
		console.log('events=======>' + JSON.stringify(this.events));
		console.log('all sessions 198=======>' + JSON.stringify(this.Allsessions));
		console.log('selected event 199=======>' + JSON.stringify(this.selectedEvent));
		console.log('selected IDS 200=======>' + JSON.stringify(this.selectedIDS));
		console.log('event checked=======>' + event.target.checked);
		const childCheckboxes = this.template.querySelectorAll(`.session-checkbox[data-parent-event-id="${selectedEventId1}"]`);
		if (childCheckboxes.length > 0) {
			if (event.target.checked) {
				childCheckboxes.forEach(checkbox => {
					checkbox.checked = true;
				});
			} else {
				childCheckboxes.forEach(checkbox => {
					checkbox.checked = false;
				});
			}
		}
		let a = null;
		this.events.forEach(eventRecord => {
			if (eventRecord.Id == selectedEventId1) {
				a = eventRecord;
				//console.log("aaaaaaaa=======" + a.hasOwnProperty('Sessions__r'));

				if (a.hasOwnProperty('OrgEventManager__Sessions__r')) {
					if (a.OrgEventManager__Sessions__r.length > 0) {
						a.OrgEventManager__Sessions__r.forEach(session => {
							//console.log('Session ID=======>', session.Id);
							if (this.Allsessions.includes(session.Id)) {
								console.log('inside if 232=======>');
								this.Allsessions = this.Allsessions.filter(lang => lang !== session.Id);
							} else {
								console.log('inside else 235=======>');
								this.Allsessions = [...this.Allsessions, session.Id];
							}
						});
					}
				}
			}
		});
		console.log('All session Id from Event========>', JSON.stringify(this.Allsessions));
		if (this.selectedEvent.includes(selectedEventLabel) && this.selectedIDS.includes(selectedEventId1)) {
			// If selected, remove it from the selectedLanguages array
			console.log('inside if 315=======>');
			this.selectedEvent = this.selectedEvent.filter(lang => lang !== selectedEventLabel);
			this.selectedIDS = this.selectedIDS.filter(lang => lang !== selectedEventId1);
			console.log('all sessions 319=======>' + JSON.stringify(this.Allsessions));
			console.log('selected event 320=======>' + JSON.stringify(this.selectedEvent));
			console.log('selected IDS 321=======>' + JSON.stringify(this.selectedIDS));
		} else {
			// If not selected, add it to the selectedLanguages array
			console.log('inside else 321=======>');
			this.selectedEvent = [...this.selectedEvent, selectedEventLabel];
			this.selectedIDS = [...this.selectedIDS, selectedEventId1];
			console.log('all sessions 327=======>' + JSON.stringify(this.Allsessions));
			console.log('selected event 328=======>' + JSON.stringify(this.selectedEvent));
			console.log('selected IDS 329=======>' + JSON.stringify(this.selectedIDS));
		}
	}

	

	handleBack03() {
		this.FirstPage = true;
		//this.SecondPage = true;
		this.FourthPage = false;
		this.FifthPage = false;
		this.SixthPage = false;
		this.SeventhPage = false;
		this.NinthPage = false;
		window.scrollTo(0, 0);
	}

	@track count;
	@track sampledata;
	handleContinue03() {
		this.FirstPage = false;
		//this.SecondPage = false;
		this.FourthPage = false;
		this.FifthPage = true;
		this.SixthPage = false;
		this.SeventhPage = false;
		this.NinthPage = false;

		const selectedMultipleevent = this.selectedIDS.join(';');
		console.log('selectedMultipleevent Id========>' + selectedMultipleevent);

		selectedEvents({
				SelectedValue1: selectedMultipleevent
			})
			.then((result) => {
				this.sampledata = result;
				console.log('sampledata ----', JSON.stringify(result));

				this.showEvents = result.map(event => {
					const modifiedEvent = {
						...event
					};
					modifiedEvent.OrgEventManager__Event_Language__c = event.OrgEventManager__Event_Language__c.split(';').map(language => language.trim()).join(', ');
					return modifiedEvent;
				});
				// this.modifyeventHandlerForSelection(this.showEvents);
				console.log('result 2024=======>' + JSON.stringify(this.showEvents));
			})
			.catch((error) => {
				this.error = error;
				console.log('error--->>>>>>> ' + JSON.stringify(this.error));
			});
		//Record  creation event registration
		window.scrollTo(0, 0);
	}

	handleBack04() {
		this.FirstPage = false;
		//this.SecondPage = false;
		this.FourthPage = true;
		this.FifthPage = false;
		this.SixthPage = false;
		this.SeventhPage = false;
		this.NinthPage = false;
		window.scrollTo(0, 0);
	}

	handleContinue04() {
		this.FirstPage = false;
		//this.SecondPage = false;
		this.FourthPage = false;
		this.FifthPage = false;
		this.SixthPage = true;
		this.SeventhPage = false;
		this.NinthPage = false;
		window.scrollTo(0, 0);
	}

	handleCheckChange(event) {
		this.contactObject.OrgEventManager__Consent_Checkbox__c = event.target.checked;
	}

	handleBack05() {
		window.scrollTo(0, 0);
		this.FirstPage = false;
		//this.SecondPage = false;
		this.FourthPage = false;
		this.FifthPage = true;
		this.SixthPage = false;
		this.SeventhPage = false;
		this.NinthPage = false;
	}

	@track hasPreviousCgContacts = false;
	@track caregiverFormFlag = true;
	handleContinue05() {
		window.scrollTo(0, 0);
		let CheckfieldCmp = this.template.querySelector(".CheckfieldClass");
		if (!CheckfieldCmp.value) {
			CheckfieldCmp.setCustomValidity("Please check the checkbox.");
		} else {
			CheckfieldCmp.setCustomValidity(""); // clear previous value
		}
		CheckfieldCmp.reportValidity();

		if (!this.contactObject.OrgEventManager__Consent_Checkbox__c) {
			
			this.FirstPage = false;
			//this.SecondPage = false;
			this.FourthPage = false;
			this.FifthPage = false;
			this.SixthPage = true;
			this.SeventhPage = false;
			this.NinthPage = false;
		} else {
			
			this.FirstPage = false;
			//this.SecondPage = false;
			this.FourthPage = false;
			this.FifthPage = false;
			this.SixthPage = false;
			this.SeventhPage = true;
			this.NinthPage = false;

			showAttendeeRecords({})
			.then((result) => {

				if (result && result.length > 0) {
					this.showPreviousCgContacts = result;
					this.hasPreviousCgContacts = true;
					this.caregiverFormFlag = false;
				} else {
					this.hasPreviousCgContacts = false;
					this.caregiverFormFlag = true;
				}
				console.log('List of Previous Cg Contacts', JSON.stringify(this.showPreviousCgContacts));
			})

			.catch((error) => {
				this.error = error;
				console.log('Error=', error);
				this.hasPreviousCgContacts = false;
			});
		}
		
	}
	handleAddNewCaregiver() {
		this.caregiverFormFlag = true;
	}

	@track cgContactIds = [];
	@track cgContactId = null; // Variable to store the first ID
	@track showPreviousCgContacts = [];
	handleCgCheckboxChange(event) {
		const contactId = event.currentTarget.dataset.eventId;
		console.log('seleced CG Contact Id from CG Form====' + contactId);

		if (this.cgContactIds.includes(contactId)) {
			this.cgContactIds = this.cgContactIds.filter(lang => lang !== contactId);
		} else {
			this.cgContactIds = [...this.cgContactIds, contactId];
			// Store the first selected checkbox ID if it's not already set
			if (this.cgContactId === null) {
				this.cgContactId = contactId;
			}
		}
		console.log('SElected Caregiver Id=======>' + JSON.stringify(this.cgContactIds));
		console.log('First Selected Caregiver Id=====>' + this.cgContactId);
	}

	
	@wire(getObjectInfo, {
		objectApiName: CONTACT_OBJECT
	})
	contactInfo;
	
	@track optionsGender;
	@track optionsCountry;
	
	@wire(getPicklistValues, {
		recordTypeId: '$contactInfo.data.defaultRecordTypeId',
		fieldApiName: gender
	})
	gender1({data,error}) {
		if (data) {
			this.optionsGender = data.values;
		} else {
			console.log('error:: ', error);
		}
	}

	@wire(getPicklistValues, {
		recordTypeId: '$contactInfo.data.defaultRecordTypeId',
		fieldApiName: country
	})
	country1({data,error}) {
		if (data) {
			this.optionsCountry = data.values;
		} else {
			console.log('error:: ', error);
		}
	}
	
	
	handleBack06() {
		this.FirstPage = false;
		//this.SecondPage = false;
		this.FourthPage = false;
		this.FifthPage = false;
		this.SixthPage = true;
		this.SeventhPage = false;
		this.NinthPage = false;
		window.scrollTo(0, 0);
	}
		

	async handleAlertClick(mymessage) {
		await LightningAlert.open({
			message: mymessage,
			theme: "error", // a red theme intended for error states
			label: "Error!", // this is the header text
		});
		window.scrollTo(0, 0);
	}


		
	async newHandleEventRegitsrtaionRecord() {
		const selectedeventt = this.selectedIDS.join(',');
		console.log("Selected EventIds=======", selectedeventt);
		console.log('selected session Id====' + this.Allsessions);
		newEventRegitsrtaionRecord({
				selectedEventIds: selectedeventt,
				cgContactId: this.cgContactId,
				cgContactIds: this.cgContactIds,
				selectedIDSsession: this.Allsessions
			})
			.then((result) => {
				console.log('Online Registration Id-->' + JSON.stringify(result));
				console.log('Online Registration Id-->' + JSON.stringify(result.Id));
				if (result && result.Id) {
					this.OnlineRegId = result.Id; // Extracting and setting the id
					console.log('Current Online Reg. ID-->' + this.OnlineRegId);
					this.handleDashboardSessions();
					//this.newHandleCgandPwdContact();
				} else {
					console.error('ID not found in the result');
				}
			})
			.catch((error) => {
				this.error = error;
			});
	}

	/*async newHandleCgandPwdContact() {
		newUpdateCgandPwdContact({
				cgContactIds: this.cgContactIds
			})
			.then((result) => {
				console.log('handleCgandPwdContact', result);
			})
			.catch((error) => {
				this.error = error;
				console.log('Error=', error);
			});
	}*/


	//////////////////////////////
	
	
    /*optionsGender = [
        { label: 'Male', value: 'Male' },
        { label: 'Female', value: 'Female' },
        { label: 'Other', value: 'Other' }
    ];*/

	@track contactForms = [];
    @track isAddDisabled = false;

    /*connectedCallback() {
        this.handleAddForm(); // Initialize with one form
    }*/

    handleAddForm() {
		// Validate the last form before allowing a new one
		if (this.contactForms.length > 0) {
			const lastForm = this.contactForms[this.contactForms.length - 1];
			for (const [key, value] of Object.entries(lastForm)) {
				if (key !== 'id' && key !== 'label' && !value) {
					this.handleAlertClick(`Please fill out all fields in ${lastForm.label} before adding a new person.`);
					return; // Stop execution
				}
			}
		}

		// Add a new form if validation passes
		if (this.contactForms.length < 6) {
			const newIndex = this.contactForms.length + 1; // Calculate the index for the new form
			this.contactForms.push({
				id: Date.now(),
				label: `Person ${newIndex}`, // Precompute the label
				LastName: '',
				OrgEventManager__Gender__c: '',
				Email: '',
				MobilePhone: '',
				OrgEventManager__Country__c: '',
				OrgEventManager__Postal_Code1__c: ''
			});
		}
		this.isAddDisabled = this.contactForms.length === 6;
	}
	

    handleDeleteForm(event) {
		const index = event.target.dataset.index;
		this.contactForms.splice(index, 1);
		
		// Update labels after deletion
		this.contactForms = this.contactForms.map((form, idx) => ({
			...form,
			label: `Person ${idx + 1}`
		}));
	
		this.isAddDisabled = this.contactForms.length >= 6;
	}
	

    handleInputChange(event) {
        /*const index = event.target.dataset.index;
        const fieldName = event.target.name;
		 
        this.contactForms[index][fieldName] = event.target.value;*/

		const index = event.target.dataset.index; // Get the form index
		const fieldName = event.target.name;     // Get the field name
		const value = event.target.value;        // Get the field value

		// Update the specific form field
		this.contactForms = this.contactForms.map((form, idx) => {
			if (idx === Number(index)) {
				return {
					...form,
					[fieldName]: value, // Update the specific field
				};
			}
			return form;
		});
		
		console.log('handleInputChange contactForms:', JSON.stringify(this.contactForms));
    }

    handleSubmit() {
		window.scrollTo(0, 0);
		// Get all checkboxes
		const checkboxes = this.template.querySelectorAll('.cgContactCheckboxClass');
		const isAnyCheckboxChecked = Array.from(checkboxes).some(checkbox => checkbox.checked);

		 // Validation checks
		 /*if (!this.hasPreviousCgContacts && this.contactForms.length === 0) {
			// Case 1: No previous contacts and no forms
			this.handleAlertClick('Please add at least one person.');
			return; // Stop execution
		} else if (!isAnyCheckboxChecked && this.contactForms.length === 0) {
			// Case 2: Previous contacts exist but none selected, and no forms
			this.handleAlertClick('Please click on one of the checkboxes to select from previous registered attendee or fill in the form if you wish to add a new attendee.');
			return; // Stop execution
		} else if (isAnyCheckboxChecked && this.caregiverFormFlag == true && this.contactForms.length === 0) {
			// Case 3: A checkbox is selected, caregiver form flag is true, but no forms exist
			this.handleAlertClick('Please fill the required fields in the form.');
			return; // Stop execution
		}*/

		// Function to check if a form is completely blank
		// Updated isFormBlank function
		/*const isFormBlank = (form) => {
			const checkValue = (value) => {
				if (value === null || value === undefined) return true; // Treat as blank
				if (typeof value === 'object') return isFormBlank(value); // Recursive check
				if (typeof value !== 'string') return false; // Non-string values are invalid
				return value.trim() === ''; // String-specific check
			};
			return Object.values(form).every(checkValue);
		};
		
	
		const areAllFormsBlank = this.contactForms.every(isFormBlank);
		console.log('Final contactForms:', JSON.stringify(this.contactForms));
		console.log('areAllFormsBlank:', areAllFormsBlank);*/

		
		// Validation checks
		if (!this.hasPreviousCgContacts && this.contactForms.length === 0) {
			this.handleAlertClick('Please add at least one person.');
			return; // Stop execution
		} else if (!isAnyCheckboxChecked && this.contactForms.length === 0) {
			this.handleAlertClick('Please click on one of the checkboxes to select from previous registered attendee or fill in the form if you wish to add a new attendee.');
			return; // Stop execution
		} else if (isAnyCheckboxChecked && this.caregiverFormFlag==true && this.contactForms.length === 0) {
			this.handleAlertClick('Please fill the required fields in the form.');
			return; // Stop execution
		}
		console.log('Final contactForms:', JSON.stringify(this.contactForms));
		

	// Validate each form to ensure no fields are left blank
		let isValid = true;
		let errorMessage = '';
	
		// Validate each form
		this.contactForms.forEach((form, index) => {
			for (const [key, value] of Object.entries(form)) {
				if (key !== 'id' && key !== 'label' && !value) {
					isValid = false;
					errorMessage = `Please fill out all required fields in Person ${index + 1}.`;
					return;// Stop further validation
				}
			}
		});
	
		if (!isValid) {
			this.handleAlertClick(errorMessage);
			return; // Stop execution
		}
	
		// Remove front-end-only properties like `id` and `label`
		const contactList = this.contactForms.map(form => {
			const { id, label, ...contactData } = form; // Destructure to exclude `id` and `label`
			return contactData;
		});

		console.log('Submitting contacts:', JSON.stringify(contactList)); // Log for debugging
		console.log('First Contact Id=====>' + this.cgContactId);
		console.log('Multiple Contact Ids=======>' + JSON.stringify(this.cgContactIds));
		

		createContacts({ contactList,consentAcknowledged: this.contactObject.OrgEventManager__Consent_Checkbox__c})
			.then((result) => {
				/*const { contactsToInsert, contactsToUpdate } = result;

				// Merge both lists into one array
				const allContacts = [...contactsToInsert, ...contactsToUpdate];
	
				// Store the first contact ID
				if (!this.cgContactId) {
					this.cgContactId = allContacts[0].Id;
					console.log('First Cg Id====>' + this.cgContactId);
				}
	
				// Store all unique IDs
				const contactIds = allContacts.map(contact => contact.Id);
				this.cgContactIds = [...new Set([...this.cgContactIds, ...contactIds])];
	
				// Properly log the IDs				
				console.log('Length of Updated Contact IDs:', this.cgContactIds.length);
				this.cgContactIds.forEach((id, index) => {
					console.log(`Contact ID at index ${index}: ${id}`);
				});
	
				console.log('Updated Contact IDs as JSON:', JSON.stringify(this.cgContactIds));*/

				// Destructure the result to get the contacts to insert
				const { contactsToInsert } = result;

				/*if (!contactsToInsert || contactsToInsert.length === 0) {
					console.warn('No contacts were returned by the server.');
					return;
				}*/
		
				// Store the first contact ID
				if (!this.cgContactId && contactsToInsert.length > 0) {
					this.cgContactId = contactsToInsert[0].Id;
					console.log('First Contact ID (cgContactId):', this.cgContactId);
				}
		
				// Extract and store all unique contact IDs
				const contactIds = contactsToInsert.map(contact => contact.Id);
				this.cgContactIds = [...new Set([...this.cgContactIds, ...contactIds])];
		
				// Log the updated list of contact IDs
				console.log('Total Unique Contact IDs:', this.cgContactIds.length);
				this.cgContactIds.forEach((id, index) => {
					console.log(`Contact ID at index ${index}: ${id}`);
				});
		
				// Log the entire set of IDs as a JSON string (for debugging purposes)
				console.log('Updated Contact IDs (JSON):', JSON.stringify(this.cgContactIds));
		

				this.contactForms = []; // Reset forms
				this.isAddDisabled = false; // Enable add button
				this.handleAddForm(); // Add initial form
				this.newHandleEventRegitsrtaionRecord();
			})
			.catch((error) => {
				console.error('Error while creating contacts:', error);
			});

			const idofeachevent = this.selectedIDS.join(';');

			console.log("Selected Languages:", idofeachevent);
			selectedEventsInDashBoard({
					allIDS: idofeachevent
				})
				.then((result) => {
					this.InDashBoard = result;
					console.log(result);
				})

				.catch((error) => {
					this.error = error;
				});
			const selectedMultipleevent = this.selectedIDS.join(';');
			console.log('selectedMultipleevent Id====>' + selectedMultipleevent);

			 // All validations passed, proceed to the next page
			 
			 this.FirstPage = false;
			 //this.SecondPage = false;
			 this.FourthPage = false;
			 this.FifthPage = false;
			 this.SixthPage = false;
			 this.SeventhPage = false;
			 this.NinthPage = true;
	}
	

	/////////////////////////////



	@track showDashBoard;
	
	@track OnlineRegId;
	@track DashBoardSessions;
	

	async handleDashboardSessions() {
		const selectedeventt = this.selectedIDS.join(',');
		console.log("Selected EventIds=======", selectedeventt);
		statusUpdateMethod({
				selectedEventIds: selectedeventt,
				cgContactIds: this.cgContactIds
			})
			.then((result) => {
				let uniqueSessions = new Set();
				console.log('status updated final dashboard --------' + JSON.stringify(result));
				this.DashBoardSessions = result.map(item => ({
					sessionName: item.Name,
					sessionStatus: item.OrgEventManager__Attendees__r.OrgEventManager__Status__c,
					sessionstatus: item.OrgEventManager__Events__r.OrgEventManager__Event_State__c,
					sessionMode: item.OrgEventManager__Session_Mode__c,
					sessionStartTime: item.OrgEventManager__Start_Time__c,
					sessionEndTime: item.OrgEventManager__End_Time__c,
					sessionDate: item.OrgEventManager__Date_of_session__c,
					eventName: item.OrgEventManager__Events__r.Name,
					venueName: item.OrgEventManager__Venue__c,
					remarKs: item.OrgEventManager__Remarks__c,
					eventProgrammes: item.OrgEventManager__Events__r.OrgEventManager__Type_of_Programme__c,
					eventLanguage: item.OrgEventManager__Events__r.OrgEventManager__Event_Language__c.replace(/;/g, ', '),
					imglastdashboard : item.OrgEventManager__Events__r.OrgEventManager__Event_Image_Link__c,
					registeredContacts: item.OrgEventManager__Attendees__r.map(contact => ({
						contactId: contact.Id,
						contactName: contact.Name,
						contactnamecg: contact.OrgEventManager__Name_of_Attendees__r.Name,
						contactStatus: contact.OrgEventManager__Status__c
					}))
				}));
				console.log('this.DashBoardSessions--' + JSON.stringify(this.DashBoardSessions));
			})
			.catch((error) => {
				this.error = error;
				console.log('DashBoardSessions Error' + JSON.stringify(error));
				console.log('DashBoardSessions Error===' + JSON.stringify(this.error));
			});
	}
	

	@track CSGOpen;

	@track currentUserName;
	@wire(getRecord, {
		recordId: Id,
		fields: [UserNameFIELD]
	})
	currentUserInfo({
		error,
		data
	}) {
		if (data) {
			this.currentUserName = data.fields.Name.value;
		} else if (error) {
			this.error = error;
		}
	}

	@track firstPageDashboard;
	@track isModalOpen = false;
	isModalOpenDashboard=true;
	handleMyDashBoard() {
		this.isModalOpen = true;
		this.FirstPage = false;
		//this.SecondPage = false;		
		this.FourthPage = false;
		this.FifthPage = false;
		this.SixthPage = false;
		this.SeventhPage = false;
		this.NinthPage = false;
		window.scrollTo(0, 0);
		ShowSessionFirstPageDashboard({})
			.then((result) => {
				this.firstPageDashboard = result;
				console.log(JSON.stringify(this.firstPageDashboard));
				this.firstPageDashboard = result.map(event => {
					const modifiedEvent = {
						...event
					};
					modifiedEvent.OrgEventManager__Event_Registration__r.OrgEventManager__Event__r.OrgEventManager__Event_Language__c = event.OrgEventManager__Event_Registration__r.OrgEventManager__Event__r.OrgEventManager__Event_Language__c.split(';').map(language => language.trim()).join(', ');
					return modifiedEvent;
				});
				console.log('modified inFo =======>' + JSON.stringify(this.firstPageDashboard));
			})
			.catch((error) => {
				this.error = error;
			});
	}

	@track up = false;
	@track past = false;
	@track upComSession;
	@track activeButton = '';
	@track a = '';
	@track activeLanguages = [];
	get button1Class() {
		return this.activeButton === 'button1' ? 'active' : '';
	}
	get button2Class() {
		return this.activeButton === 'button2' ? 'active' : '';
	}
	@track contentVersions; @track summaTion = true; @track Notfound = '';
	handleUpcommingSessions(event) {
		const buttonId = event.target.dataset.id;
		this.activeButton = buttonId;
		console.log(this.activeButton);
		getUpcommingSessions({})
			.then((result) => {
				//console.log('result======>',JSON.stringify(result));
				this.upComSession = result;
              //  const { sessionContentDocumentUrls, sessions } = result;
				this.upComSession = result.map(event => {
					const modifiedEvent = {
						...event,
                       // contentdocurl: sessionContentDocumentUrls[event.Id] || this.imageUrl
					};
					modifiedEvent.OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_Language__c = event.OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_Language__c.split(';').map(language => language.trim()).join(', ');
					return modifiedEvent;
				});
				this.modifyDashboardEvents(this.upComSession);
				this.hideWithdrawButton(this.groupEvent);
				console.log('groupEvent 183========>',JSON.stringify(this.groupEvent));  
				if(this.groupEvent.length > 0){
					this.summaTion = true;
				}else{this.summaTion = false; this.Notfound = 'You do not have any upcoming events.'}
			})
			.catch((error) => {
                console.log('err=====',error);
				this.error = error;
			});
	}
	@api groupEvent = [];
	modifyDashboardEvents(data) {
		console.log('data 187===>' + JSON.stringify(data));

		const groupedData = {};
		data.forEach(item => {
			const groupName = item.OrgEventManager__Session__r.OrgEventManager__Events__r.Name;
			const Eventstatee = item.OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_State__c;
			const sessionId = item.OrgEventManager__Session__r.Id;
			const conId = item.OrgEventManager__Name_of_Attendees__r.Id;
			const sessionDate = item.OrgEventManager__Session__r.OrgEventManager__Date_of_session__c;
			const dateoldone = item.OrgEventManager__Session__r.OrgEventManager__Session_Date__c;
			const typeOfProg = item.OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Type_of_Programme__c;
			const eventids = item.OrgEventManager__Session__r.OrgEventManager__Events__r.Id;
			const contentVersionUrls = item.OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_Image_Link__c;
	
			if (!groupedData[groupName]) {
				groupedData[groupName] = {
					groupName: groupName,
					Eventstatee: Eventstatee,
					typeOfProg: typeOfProg,
					cntname: [],
					firstSessionDate: dateoldone,
					hideButtonss: true, // Initialize the hide button flag,
					list: [],
					
				};
			}
			if (!groupedData[groupName].list[sessionId]) {
				groupedData[groupName].list[sessionId] = {
					sessionId: sessionId,
					sessionName: item.OrgEventManager__Session__r.Name,
					sessionMode: item.OrgEventManager__Session__r.OrgEventManager__Session_Mode__c,
					venue: item.OrgEventManager__Session__r.OrgEventManager__Venue__c,
					sessionDate: item.OrgEventManager__Session__r.OrgEventManager__Date_of_session__c,
					startTime: item.OrgEventManager__Session__r.OrgEventManager__Start_Time__c,
					endTime: item.OrgEventManager__Session__r.OrgEventManager__End_Time__c,
					remarks: item.OrgEventManager__Session__r.OrgEventManager__Remarks__c,
					eventProgrammes: item.OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Type_of_Programme__c,
					eventLanguage: item.OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_Language__c,
					contentVersionUrls: contentVersionUrls 
				};
			}
			if (!groupedData[groupName].cntname[conId]) {
				groupedData[groupName].cntname[conId] = {
					conId: item.OrgEventManager__Name_of_Attendees__r.Id,
					contactnav: item.OrgEventManager__Name_of_Attendees__r.LastName,
					statussess: item.OrgEventManager__Status__c
				};
			}
		});
		console.log('groupedData 277======>',JSON.stringify(groupedData));

		this.groupEvent = Object.keys(groupedData).map(event => {
			return {
				groupName: groupedData[event].groupName,
				Eventstatee: groupedData[event].Eventstatee,
				typeOfProg: groupedData[event].typeOfProg,
				cntname: Object.values(groupedData[event].cntname),
				firstSessionDate: groupedData[event].firstSessionDate,
				list: Object.values(groupedData[event].list),
				hideButtonss: groupedData[event].hideButtonss
			};
		});
		console.log('groupEvent 285======>',JSON.stringify(this.groupEvent));
	} 
	@track hideButton = true;
	hideWithdrawButton(data) {
		const today = new Date();
		const todayString = today.toISOString().split('T')[0]; console.log("todayString" ,todayString);
	
		data.forEach(eventData => {
			const firstSessionDate = new Date(eventData.firstSessionDate); console.log("firstSessionDate" ,firstSessionDate);
			firstSessionDate.setDate(firstSessionDate.getDate() - 14);
			const firstSessionDateString = firstSessionDate.toISOString().split('T')[0];
	         
			console.log('Current date:', todayString);
			console.log('First session date minus 14 days:', firstSessionDateString);
			
			if (todayString >= firstSessionDateString) {
				eventData.hideButton = false;
				console.log('Button will disappear');
			} else {
				eventData.hideButton = true;
				console.log('Button will not disappear');
			}
		});
	
		this.groupEvent = data;
		console.log('Updated groupEvent:', JSON.stringify(this.groupEvent));
	}

	@track openmodalpopup = false;
    @track nameevent = '';
    @track conid = '';
    notiFireDashboard(event) {
        this.openmodalpopup = true;
        const contactId = event.target.dataset.contactId;
        const eventId = event.target.dataset.eventId;
        const sessionId = event.target.dataset.sessionId;
        this.nameevent = eventId;
        this.conid = contactId
        console.log('Contact ID:', contactId);
        console.log('Event ID:', eventId);
        console.log('Session ID:', sessionId);
        
    } 

	handleWithDraw(nameevent, conid) {
        handleWinDrawlled({
                eventId: this.nameevent,
                contactId: this.conid
            })
            .then((result) => {
                console.log(result);
                console.log('Withdraw all sessions from the same event');
				const simulatedEvent = {
					target: {
						dataset: {
							id: 'button1' // Assuming "Upcoming Sessions" is button1
						}
					}
				};
				this.handleUpcommingSessions(simulatedEvent);
                this.openmodalpopup = false;
				this.handleSuccessPopup("Your withdrawal is successful.");
            })
            .catch((error) => {
                this.error = error;
                console.error('Error during withdrawal:', error);
            });
    }

	async handleSuccessPopup(mymessage) {
		await LightningAlert.open({
			message: mymessage,
			theme: "Success", // a red theme intended for error states
			label: "Success!", // this is the header text
		});
	
		//window.scrollTo(0, 0);
	}

	handleCan() {
        this.openmodalpopup = false;
    }

	handlePastSessions(event) {
		const buttonId = event.target.dataset.id;
		this.activeButton = buttonId;
		console.log(this.activeButton);
		getPastSessions({})
			.then((result) => {
				this.upComSession = result;
				this.upComSession = result.map(event => {
					const modifiedEvent = {
						...event
					};
					modifiedEvent.OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_Language__c = event.OrgEventManager__Session__r.OrgEventManager__Events__r.OrgEventManager__Event_Language__c.split(';').map(language => language.trim()).join(', ');
					return modifiedEvent;
				});
				console.log('modified inFo =======>' + JSON.stringify(this.upComSession));
				this.modifyDashboardEvents(this.upComSession);
				console.log('modified modifyDashboardEvents' + JSON.stringify(this.upComSession));  if(this.upComSession.length > 0){
					this.summaTion = true;
				}else{this.summaTion = false; this.Notfound = 'You do not have any past events.'}
			})
			.catch((error) => {
				this.error = error;
			});
	}

	@track hideCancelButton = true;
	@track hideInner = false;
	handleOkButton() {
		this.isModalOpen = false;
		this.FirstPage = true;
		//this.SecondPage = false;
		this.FourthPage = false;
		this.FifthPage = false;
		this.SixthPage = false;
		this.SeventhPage = false;
		this.NinthPage = false;
		window.scrollTo(0, 0);
	}

	get PageDashboard() {
		return this.firstPageDashboard.length > 0;
	} 

	eventRegistrationLabel = Event_Registration_Form_URL;
	handleLogOut() {
		//const logoutUrl = 'https://dsgsg--arkpartial.sandbox.my.site.com/dsgEventRegistration/secur/logout.jsp';
		const logoutUrl = this.eventRegistrationLabel + '/secur/logout.jsp';
		window.location.href = logoutUrl;
	}

	@track finishButtonModalPopup=false;
	
		handleFinishButton(){
			this.finishButtonModalPopup=true;
		}
	
		googleUrlLabel = googleUrl;
	
		handleDashboardOkButton(){
		const okurl = this.googleUrlLabel;	
		window.location.href = okurl;
		}
		
}