public class RandomContactExtension {

    private final Contact contact;
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public RandomContactExtension (ApexPages.StandardController stdController) {
        this.contact= (Contact)stdController.getRecord();
        System.debug(this.contact.Owner);
        //this.contact.OwnerId = UserInfo.getUserId();
        //this.contact.Owner = UserInfo.getName();
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'http://api.randomuser.me';
        request.setEndPoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = httpProtocol.send(request);
        JSON2Apex j2a = JSON2Apex.parse(response.getBody());
        
        //mapping fields
        JSON2Apex.User u = j2a.results[0].user;
        DateTime bd = DateTime.newInstance(u.dob);
        this.contact.FirstName = u.name.first.capitalize();
        this.contact.LastName = u.name.last.capitalize();
        this.contact.Salutation= u.name.title.capitalize() + '.';
        this.contact.BirthDate= date.newinstance(bd.year(), bd.month(), bd.day());
        this.contact.Email=u.email;
        this.contact.Phone = u.phone;
        this.contact.MobilePhone = u.cell;
        this.contact.MailingStreet = u.location.street.capitalize();
        this.contact.MailingCity = u.location.city.capitalize();
        this.contact.MailingState = u.location.state.capitalize();
        this.contact.MailingCountry = j2a.nationality;
        this.contact.MailingPostalCode = u.location.zip;
    }
}