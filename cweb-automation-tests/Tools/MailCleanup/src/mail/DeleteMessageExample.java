package mail;

import javax.mail.*;


public class DeleteMessageExample {
  public static void main (String args[]) throws Exception {
    String host = args[0];
    String username = args[1];
    String password = args[2];

    
    // Get session
    Session session = Session.getInstance(
      System.getProperties(), null);

    // Get the store
    Store store = session.getStore("imap");
    store.connect(host, username, password);

    // Get folder
    Folder folder = store.getFolder("INBOX");
    folder.open(Folder.READ_WRITE);


    // Get directory
    Message message[] = folder.getMessages();
    for (int i=0, n=message.length; i<n; i++) {
       System.out.println("Deleting ("+i+"): " + message[i].getSubject());

     
         message[i].setFlag(Flags.Flag.DELETED, true);
       
    }

    // Close connection 
    folder.close(true);
    store.close();
  }
}