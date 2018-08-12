# Streetbees iOS developer challenge 

### Developer Notes
To run the project, in terminal, navigate to src directory and run the following command:

```bash
pod install
```

Work on the project from the **MarvelComics.xcworkspace**.

The project has two configurations: **DEV** and **PROD**, the only difference in this case is the AppIcon. But usually, configurations such as service private/public keys are different. And many other configuration attributes that vary depending on the environment.

To the comic list request, I've added the initial offset of 200 records, to avoid loading comics that don't have cover image. 

### Description
Using the best API available on this side of the universe [https://developer.marvel.com/](https://developer.marvel.com/) make a simple master detail app that allows the user to scroll through all the comics ever released and view details for each comic.

You will need to sign up for a free developer account with Marvel.

### Functional requirements (Using the Job to be Done framework)

- When I open the application I want to see a list of all Marvel’s released comic books
- When tapping on a comic it should open up a modal view controller showing the cover art full screen

Feel free to use whatever flare you can to show off your skills.

### Design

![design](design.png)
### Technical requirements
- Application must be developed for the iPhone with Swift 4, iOS 11 and xcode 9. We are not expecting iPad support.
- You are free to use whatever frameworks or tools you see fit

### Evaluation Criteria
- Adaptability. We want to see how well you can develop for the different screen sizes.
- You create maintainable code
- You create testable code
- You care about the user experience
- You pay attention to detail
- You develop in a scalable manner

### Deliverables
- The forked version of this repo
