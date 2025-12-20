**Role:** Senior Mobile Solutions Architect & AI Logic Designer
**Project Context:** Extending the "What Is" application with a new, robust module named **"Learn It"**.
**Constraint:** Strict Separation of Concerns. The Data Layer must use the **Repository Pattern**. The underlying database (SQLite, Hive, Isar, etc.) must be 100% replaceable by changing the injection, without touching the UI or Business Logic.

**1. Data Domain & Models (Detailed Schema)**
Define the following entities with these specific fields:

* **`Topic` Model:**
* `id` (String/UUID)
* `title` (String)
* `description` (String)
* `icon_key` (String/Enum - for rendering UI icons)
* `color_hex` (String - for UI theming)
* `settings` (Object/JSON):
* `target_language` (String, defaults to App Global Setting)
* `include_summary` (Boolean)
* `include_examples` (Boolean)


* `created_at` (Timestamp)


* **`LearnedItem` Model (The "Concept"):**
* `id` (String/UUID)
* `topic_id` (ForeignKey to Topic)
* `concept_title` (String - e.g., "Single Source of Truth")
* `content_body` (String - Markdown/Text explanation from AI)
* `is_understood` (Boolean - Default False)
* `learned_at` (Timestamp - Nullable, set when "Understood" is clicked)


* **`DiscussionMessage` Model (The "Semi-Chat"):**
* `id` (String/UUID)
* `learned_item_id` (ForeignKey to LearnedItem)
* `role` (Enum: 'user' | 'assistant')
* `content` (String)
* `timestamp` (Timestamp)



**2. Dashboard & Navigation UX**

* **Entry:** Add a persistent entry point (Tab or Top Bar Button) labeled "Learn It".
* **Dashboard View:**
* **Header:** Show User Statistics clearly:
* `Total Concepts Learned` (Aggregate count).
* `Daily Streak` (Calculated logic).
* `Highest Streak` (Historical max).


* **Body (Topic List):**
* List all `Topic` items.
* Each list tile must render the `title`, `description`, `icon`, and use the `color` for visual framing.
* **Empty State:** If no topics exist, show a centered "Start Learning" button.


* **Floating Action Button (FAB):** "Create Topic".
* Opens a dialog/screen to input: Title, Description, Icon Selection, Color Selection.





**3. The Active Learning Loop (The Core Flow)**

* **Initialization:** User selects a `Topic` (e.g., "Design Patterns").
* **AI Prompting Logic (The "Skip List"):**
1. Query database for all `LearnedItem.concept_title` associated with this `Topic`.
2. Construct a prompt sending this list to the AI: *"Teach me a new concept about [Topic], but SKIP these already learned concepts: ['Singleton', 'Factory', 'Observer']"*.


* **Generation State:** Show a loading indicator ("Generating new concept...").
* **Consumption State (The View):**
* Render the AI response (Title + Body).
* **Constraint:** The "Understood" button at the bottom must be **Disabled** or **Hidden** initially.
* **Scroll Logic:** The user must scroll to the very bottom of the content to enable/reveal the "Understood" button.


* **"Discuss" Mode (Semi-Chat Integration):**
* Place a "Discuss / Add Notes" button prominent in the UI.
* **Behavior:** This does *not* leave the page. It opens a **Chat Interface** (Sheet or Expandable View) linked *specifically* to the current `LearnedItem`.
* **Interaction:** User asks "What does X mean in this context?". AI responds.
* **Storage:** Save this exchange into the `DiscussionMessage` table linked to this `LearnedItem`. This creates a persistent "sub-info" history.


* **Completion:**
* User clicks "Understood".
* System saves `LearnedItem` status to `is_understood = true`.
* System updates local stats (Streak/Total).
* System triggers the **Next Generation** loop immediately (repeating the Skip List logic with the new item included).



**4. History & Review Module**

* **History Tab:** A list view of all `LearnedItem`s where `is_understood == true`, sorted by date.
* **Detail View:**
* Clicking a history item opens the `LearnedItem` detail.
* Shows the original `concept_title` and `content_body`.
* **Chat History:** Loads and displays the associated `DiscussionMessage`s (the semi-chat history).
* **Continuation:** User can continue the discussion (add more notes/questions) in this view, effectively appending to the `DiscussionMessage` log.



**5. Implementation Request**
Use drift database