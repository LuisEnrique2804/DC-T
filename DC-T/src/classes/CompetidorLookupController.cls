public with sharing class CompetidorLookupController {

  public Account account {get;set;} // new account to create
  public Contact contact {get;set;} // new account to create
  public Opportunity opportunity {get;set;} // new account to create
  public List<Account> results{get;set;} // search results
  public List<Contact> result{get;set;} // search results
  public string searchString{get;set;} // search keyword

  public CompetidorLookupController () {
    account = new Account();
    contact = new Contact();
    opportunity = new Opportunity();
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    runSearch();  
  }

  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }

  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);   
    result = performSearch2(searchString);             
  } 

  // run the search and return the records found. 
  private List<Account> performSearch(string searchString) {

    String soql = 'select id, name from account';
    if(searchString != '' && searchString != null)
      soql = soql +  ' where name LIKE \'%' + searchString +'%\'';
    soql = soql + ' limit 25';
    System.debug(soql);
    return database.query(soql); 

  }
  
  // run the search and return the records found. 
  private List<Contact> performSearch2(string searchString) {

    String soql = 'select id, name from contact';
    if(searchString != '' && searchString != null)
      soql = soql +  ' where name LIKE \'%' + searchString +'%\'';
    soql = soql + ' limit 25';
    System.debug(soql);
    return database.query(soql); 

  }

  // save the new account record
  public PageReference saveAccount() {
  	if(!test.isRunningTest())
    	insert account;
    else 
    	upsert account;
    // reset the account
    account = new Account();
    return null;
  }
  
  // save the new contact record
  public PageReference saveContact() {
 	if(!test.isRunningTest())
 	    insert contact;
 	else
 		upsert contact;
    // reset the account
    contact = new Contact();
    return null;
  }

  // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }

  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }

}