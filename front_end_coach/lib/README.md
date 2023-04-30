# Front_End_Coach Main Application
This is the main application for the Front_End_Coach project. It is a web application that allows coaches to view the habits of their clients.
This file is intended to be a high-level overview of the project and its structure.

## Files
### main.dart
This file contains the `main` method, which is the entry point for the application. It is responsible for setting up the application and running it. It displays a FutureBuilder, which displays a loading screen while determining whether the user is logged in or not. If the user is logged in, it displays the `DashboardScreen` widget. If the user is not logged in, it displays the `LoginScreen` widget.
### router.dart
This file contains the `HabitRouter` class, an extension of the `GoRouter` class. It is responsible for handling the routing for the application. It is used to determine which screen to display when the user navigates to a certain URL. Used in `main.dart`.
 
## Directories
### /assets
This directory contains _code-based_ assets. As of now, this directory contains:
| File | Description |
| ---- | ----------- |
| `constants.dart` | This file contains constants that are used throughout the application. |

### /errors
This directory contains custom error classes used throughout the application. As of now, this directory contains:
| File | Description |
| ---- | ----------- |
| `api_error.dart` | This file contains the `ApiError` class, which is used to represent errors that occur when making API calls. |

### /models
This directory contains the models used throughout the application. As of now, this directory contains:
| File | Description |
| ---- | ----------- |
| `client_model.dart` | This file contains the `Client` class, which is used to represent a client. |
| `task_model.dart` | This file contains the `Task` class, which is used to represent a task/habit. |

### /providers
This directory contains the providers used throughout the application. These are classes designed to retrieve data from the API, format it, and return it to the application for processing. As of now, this directory contains:
| File | Description |
| ---- | ----------- |
| `abstract_http_api_helper.dart` | This file contains the `AbstractHttpApiHelper` class, which is an abstract class that is used to provide a base for the other providers. |
| `http_api_helper.dart` | This file contains the `HttpApiHelper` class, which is the highest-level concrete provider. It contains basic `get`, `put`, `post` operations. |
| `habit_api_helper.dart` | This file contains the `HabitApiHelper` class, which is a concrete provider that is used to retrieve habit data from the API. It provides more specific functionality needed by our application. |
| `placeholder_db_helper.dart` | This file contains the `FakeAPI` class, which is a concrete provider that is used to retrieve information that isn't currently available from the api, but is needed to implement certain features. |

### /screens
This directory contains the screens used throughout the application. These are the pages that the user sees. As of now, this directory contains:
| File | Description |
| ---- | ----------- |
| `/auth/login_screen.dart` | This file contains the `LoginScreen` class, which is the screen that the user sees when they first open the application. |
| `/auth/register_screen.dart` | This file contains the `RegisterScreen` class, which is the screen that the user sees when they want to register a new account. |
| `abstract_screen_widget.dart` | This file contains the `AbstractScreenWidget` class, which is an abstract class that is used to provide a base for the other screens. |
| `dashboard_screen.dart` | This file contains the `DashboardScreen` class, which is the screen that the user sees when they are logged in. It is going to be developed to be a tabbed view, but is currently a single view of client information. |
| `error_screen.dart` | This file contains the `ErrorScreen` class, which is the screen that the user sees when an error occurs that the application cannot handle (e.g. network failure). |
| `loading_screen.dart` | This file contains the `LoadingScreen` class, which is the screen that the user sees when the application is loading. |

### /widgets
This directory contains multiple subdirectories that contain the widgets used throughout the application. These are the components that make up the pages that the user sees.
#### /widgets/cards
This directory contains the widgets that are used to display information about a client. It also contains the `components` subdirectory, which contains widgets used to compose a card widget.
The files in this directory are:
| File | Description |
| ---- | ----------- |
| `clients_card.dart` | This file contains the `ClientsCard` class, which is a widget that is used to display information about a client. It is used in the `ClientTab` view. |
| `habits_card.dart` | This file contains the `HabitsCard` class, which is a widget that is used to display information about a client's habits. It is used in the `HabitsTab` view. |
| `components/info_component.dart` | This file contains the `InfoComponent` class, which is a widget that is used to display information about a client. It is used in the `ClientsCard` widget. |
| `components/statistics_widget_group.dart` | This file contains the `StatisticsWidgetGroup` and `StatisticsWidget` classes, which are widgets used to display information about a client's statistics. It is used in the `InfoComponent` widget. |

#### /widgets/charts
This directory contains the widgets that are used to display charts. The files in this directory are:
| File | Description |
| ---- | ----------- |
| `week_chart.dart` | This file contains the `WeekChart` class, which is a widget that is used to display an `SfCartesianChart` Line Chart of a client's habits over the past week. It is used in the `ClientsCard` widget. |

#### /widgets/modal
This directory contains the widgets that are used to display modal dialogs. The files in this directory are:
| File | Description |
| ---- | ----------- |
| `client_modal.dart` | This file contains the `ClientModal` class, which is a widget that is used to display a modal dialog that allows the user to select a client. It is used in the `ClientsCard` widget's `onTap` method. |

#### /widgets/tabs
This directory contains the widgets that are used to display tabs. The files in this directory are:
| File | Description |
| ---- | ----------- |
| `client_tab.dart` | This file contains the `ClientTab` class, which is a widget that is used to display a tab that contains information about a client. It is used in the `DashboardScreen` widget. Currently the only completed and displayed. |
| `habits_tab.dart` | This file contains the `HabitsTab` class, which is a widget that will be used to display a tab that contains information about habits. It is used in the `DashboardScreen` widget. Currently not completed or displayed. |
| `goals_tab.dart`  | This file contains the `GoalsTab` class, which is a widget that will be used to display a tab that contains information about goals set by a coach. It is used in the `DashboardScreen` widget. Currently not completed or displayed. |