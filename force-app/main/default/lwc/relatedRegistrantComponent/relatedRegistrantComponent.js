import { LightningElement,api,track,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getRelatedSessionRegisteredContact from '@salesforce/apex/EventRegistrationClass.getRelatedSessionRegisteredContact';


const COLUMNS = [
    { label: 'Registrant ID', 
        fieldName: 'REgistredPWDCOntact', 
        type: 'url', 
        typeAttributes: { 
            label: { fieldName: 'REgistredPWDCOntact123' }, 
            target: '_blank' 
        } ,
         sortable: "true"
    },
    { 
        label: 'Name of Registrant', 
        fieldName: 'PwdNameLink', 
        type: 'url', 
        typeAttributes: { 
            label: { fieldName: 'PwdNameLink123' }, 
            target: '_blank' 
        } ,
         sortable: "true"
    },
  
    { label: 'Registrant Gender', fieldName: 'OrgEventManager__Registrant_Gender__c',
         sortable: "true"
     },
   
];

export default class RelatedRegistrantComponent extends NavigationMixin(LightningElement) {

    @api recordId;
    columns = COLUMNS;
    @track recordCount = 0;
    data;
    error;
    @track sortBy;
    @track sortDirection;

    @wire(getRelatedSessionRegisteredContact, { Ids: '$recordId' })
    wiredContacts({ error, data }) {
        console.log('recordId ID: ', this.recordId);
        if (data) {
            const uniqueData = this.getUniqueRecords(data);
            this.data = uniqueData.map(record => {
                return {
                    ...record,
                    //PwdNameLink: `/lightning/r/${record.Name_of_Pwd__r.Id}/view`,
                    PwdNameLink123: record.OrgEventManager__Name_of_Registrant__r ? record.OrgEventManager__Name_of_Registrant__r.Name : '',
                    PwdNameLink: `/lightning/r/Contact/${record.OrgEventManager__Name_of_Registrant__r.Id}/view`,
                    SessionRegisteredCgContactLink123: record.OrgEventManager__Attendee__r ? record.OrgEventManager__Attendee__r.Name : '',
                    SessionRegisteredCgContactLink: `/lightning/r/OrgEventManager__Attendee__c/${record.OrgEventManager__Attendee__r.Id}/view`,
                    REgistredPWDCOntact123: record.Id ? record.Name : '',
                    REgistredPWDCOntact: `/lightning/r/OrgEventManager__Regsitrant__c/${record.Id}/view`,

                };
            });
            this.recordCount = this.data.length;
            console.log('All data' + this.data);
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }

    getUniqueRecords(data) {
        const recordMap = new Map();
        data.forEach(record => {
            if (!recordMap.has(record.OrgEventManager__Name_of_Registrant__r.Id)) {
                recordMap.set(record.OrgEventManager__Name_of_Registrant__r.Id, record);
            }
        });
        return Array.from(recordMap.values());
    }


    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.data));
        
        let keyValue = (a) => {
            return a[fieldname];
        };
        
        let isReverse = direction === 'asc' ? 1: -1;
       
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.data = parseData;
    }    


}