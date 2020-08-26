import { css } from "uebersicht";

/* USER VARIABLES */

const SHOW_HEADER = false;
const START_EXPANDED = true;
// Number of days from today after which notes will appear less opaque
const IMPORTANCE_INTERVAL = 14;

// Set whether deadlines that have passed will be hidden or not
const IGNORE_PASSED_DATES = true;

// Your notes. You can import these from a file if you wish to.
const NOTES = [
  {
    text: "ASE - Find Supervisor",
    done: false,
    deadline: "2020-09-04",
  },
  {
    text: "ASE - First Draft",
    done: false,
    deadline: "2020-10-05",
  },
];

/**
 * Position of bar, defaults to authentic top left.
 * There is 10px of padding to give margin.
 * default: { padding: 10 }
 */
export const className = {
  zIndex: 3,
  top: 0,
  left: 0,
  width: "100%",
  height: "100%",
  padding: 0,
  color: "#fff",
  fontFamily: "Helvetica",
};

const bgStyle = css`
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  margin: 0;
  padding: 0;
  background-repeat: no-repeat;
  background-size: cover;
  background-position: center;
  z-index: 1;
  background-image: url("to-do-list.widget/assets/bg.jpg");
`;

const bgStyleLayer = css`
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  margin: 0;
  padding: 0;
  background-repeat: no-repeat;
  background-size: cover;
  background-position: center;
  z-index: 5;
  background-image: url("to-do-list.widget/assets/m.png");
`;

const notesListWrapper = css`
  z-index: 3;
  //opacity: 0.8;
  position: absolute;
  top: 40%;
  right: 13%;
  display: flex;
  flex-direction: column;
  .note-item-deadline {
    // z-index: 3;
    min-width: 90px;
    text-align: center;
    background: rgba(23, 23, 23, 0.2);
    margin-right: 8px;
    padding: 8px;
    border-radius: 4px;
  }
  .upcoming {
    background-color: rgba(255, 80, 80, 0.4);
  }
  .done {
    background-color: rgba(125, 255, 80, 0.4);
  }
  .note-item-text {
    padding: 8px;
  }
`;

const header = css`
  font-size: 24px;
  margin-bottom: 10px;
  display: flex;
`;

const headerText = css`
  margin-right: 18px;
`;

const screenWrapper = css`
  z-index: 0;
  width: 100%;
  height: 100%;
  left: 0;
  top: 0;
  position: absolute;
  background: rgba(125, 125, 125, 0.5);
`;

const noteItem = css``;

const injectStyle = (style) => {
  const styleElement = document.createElement("style");
  let styleSheet = null;

  document.head.appendChild(styleElement);

  styleSheet = styleElement.sheet;

  styleSheet.insertRule(style, styleSheet.cssRules.length);
};

const keyframesStyle = `
@-webkit-keyframes pulse {
  0% {
    -webkit-transform: scale(1);
    transform: scale(1);
  }

  50% {
    -webkit-transform: scale(1.25);
    transform: scale(1.25);
  }

  100% {
    -webkit-transform: scale(1);
    transform: scale(1);
  }
}`;

injectStyle(keyframesStyle);

/**
 * The polling rate/time between each update.
 * Default: 30000 (30 seconds)
 */
export const refreshFrequency = 30000;

/**
 * @const {State}
 * Initial state of notes.
 */
export const initialState = {
  notes: NOTES,
  expanded: START_EXPANDED,
};

/**
 * @param {Event} event         The event causing the state update.
 * @param {State} previousState The previous/current state rendered.
 */
export const updateState = (event, previousState) => {
  if (event.error) {
    console.error("ERROR: ", event.error);
    return previousState;
  }

  const notes = previousState.notes;

  if (event.idx != null && notes[idx] != null) {
    notes[idx] = !notes[idx].done;
  }

  let expanded = previousState.expanded;
  if (event.toggle) {
    expanded = !expanded;
  }

  return {
    notes: notes,
    expanded: expanded,
  };
};

const toggleNoteDone = (idx) => {
  const event = { idx: idx };
  updateState(event);
};

const toggleExpanded = () => {
  const event = { toggle: true };
  updateState(event);
};

Date.prototype.addDays = function (days) {
  var date = new Date(this.valueOf());
  date.setDate(date.getDate() + days);
  return date;
};

/**
 * Render method.
 * @param {State} state The state passed in
 */
export const render = (state) => {
  const { notes } = state;

  const today = new Date();

  // Is the date within a week from now?
  const isUpcoming = (date) => date - today < 1000 * 3600 * 24 * 7;

  const sortedNotes = notes
    .map((note) => {
      return {
        text: note.text,
        done: note.done,
        deadline: new Date(note.deadline),
      };
    })
    .filter(
      (note) => !(IGNORE_PASSED_DATES && note.deadline < today.addDays(-1))
    ) // Filter out passed dates if flag is set
    .sort((a, b) => a.deadline - b.deadline);

  return (
    <div className={screenWrapper}>
      <div className={bgStyle} />
      <div className={notesListWrapper}>
        <div tabIndex="0" onClick={toggleExpanded} className={header}>
          {SHOW_HEADER && <div className={headerText}>Notes</div>}
        </div>
        <div
          className="notes-list"
          style={{ display: "flex", flexDirection: "column" }}
        >
          {state.expanded &&
            sortedNotes.map((note, i) => (
              <div
                onClick={() => toggleNoteDone(i)}
                key={i}
                className={noteItem}
                style={{
                  opacity:
                    note.deadline > today.addDays(IMPORTANCE_INTERVAL)
                      ? "0.5"
                      : "1",
                  cursor: "pointer",
                  whiteSpace: "nowrap",
                  marginBottom: "8px",
                  display: "flex",
                  flexDirection: "row",
                  textDecoration: note.done ? "line-through" : "",
                }}
              >
                <div
                  className={
                    "note-item-deadline" +
                    (isUpcoming(note.deadline) ? " upcoming" : "") +
                    (note.done ? " done" : "")
                  }
                >
                  {note.deadline.toString().slice(0, 10)}
                </div>
                <div className="note-item-text">{note.text}</div>
              </div>
            ))}
        </div>
      </div>
      <div className={bgStyleLayer} />
    </div>
  );
};
