### Summary: Include screen shots or a video of your app highlighting its features

<img src="https://github.com/user-attachments/assets/8f170b22-fead-45d8-b1f8-3cafa784d520" width="200">
<img src="https://github.com/user-attachments/assets/b5fa437a-b2a7-4777-b85c-1e7a79d2c555" width="200">
<img src="https://github.com/user-attachments/assets/f0978dec-4ca5-4640-9704-1eced9b6af78" width="200">
<img src="https://github.com/user-attachments/assets/0c0b59c1-b37a-4a7e-81af-111d5f6d335d" width="200">


### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

I mainly prioritized the implementation of my cache for the fetched recipes. I wanted to have the cache be persisted between launches
and minimize the need to make network calls as much as I can. Caching would most likely be the most time-consuming aspect of this project,
so I tackled it first.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

I spread the work over three evenings (~2 hours each):

**Day 1** – Project setup, networking layer, models  
**Day 2** – Cache implementation and persistence  
**Day 3** – UI polish (LazyVStack list, detail view) and README

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

- **List Rendering:** I switched from VStack inside ScrollView to LazyVStack. LazyVStack creates cells on demand, keeping memory proportional to visible rows. The trade-off is cache coordination because cells are recycled.  

- **Simplicity vs. Robustness:** Rather than build a full Core Data store, I decided to use Codable and FileManager for light-weight persistence, which is sufficient for the current dataset.

### Weakest Part of the Project: What do you think is the weakest part of your project?

Despite the caches storing and persisting the data correctly, I did not implement an eviction policy for the caches. This could lead to the cache growing indefinitely and consuming too much memory. The only way the cache clears is when you refresh the recipes list. Ideally, you'd want to periodically clear old entries based on some criteria like age or frequency of use, perhaps an LRU would work well here. But due to time constraints, I was unable to implement this feature.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

If I had more time, I would add comprehensive tests for the caching layer both unit and end-to-end—to cover scenarios like app restarts, failed fetches, and concurrent access. As mentioned, I would also implement a cache eviction policy, such as least-recently-used (LRU) or time-based removal, to prevent the cache from growing indefinitely. The project uses Swift Concurrency (`async/await`) and follows MVVM to ensure clarity and maintainability in the codebase.
