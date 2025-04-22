import { LightningElement,api } from 'lwc';
import getRelatedSessionPWDContact from '@salesforce/apex/EventRegistrationClass.getRelatedSessionPWDContact';
import getRelatedSessionPWDContactAttended from '@salesforce/apex/EventRegistrationClass.getRelatedSessionPWDContactAttended';

export default class AttendedRegistrantComponent extends LightningElement {

    @api recordId;

    connectedCallback(){
        console.log("jjjjjjjjjjjjj");
        this.handlePWdCount();
        this.handlePWdCountAttended();
        
    }

    handlePWdCount(){
        console.log("----" ,this.recordId);


        getRelatedSessionPWDContact({

            Ids :this.recordId

        })

            .then((result) => {
                console.log("total pwd register" , result);


            })
            .catch((error) => {

                this.error = error;

            });


    }

    handlePWdCountAttended(){
        console.log("----" ,this.recordId);


        getRelatedSessionPWDContactAttended({

            Ids :this.recordId

        })

            .then((result) => {
                console.log("result attended pwd count" , result);


            })
            .catch((error) => {

                this.error = error;

            });


        

    }
}