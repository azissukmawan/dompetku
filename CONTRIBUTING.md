

## Installation

Run the following commands from your terminal:

- Clone this repository ``` https://github.com/azissukmawan/dompetku.git ```
- ``` cd project ``` go to directory project
- ``` flutter pub get ``` in the project root directory to install all the required dependencies.

    
## Setup
find directory lib > config > api.dart

to change value ```baseUrl``` for your hosting if want use other hosting

``` dart
class Api {
  static const baseUrl = 'https://your_url.com';
  static const user = '$baseUrl/user';
  static const history = '$baseUrl/history';
}
```

for use API project, clone this project [repository](https://github.com/azissukmawan/api-dompetku) for more guide and use.
## Contributing

Contributions are always welcome!

if you have free time and want to revise or add features, Then, you can open a new [issue](https://github.com/azissukmawan/dompetku/issues), of a [pull request](https://github.com/azissukmawan/dompetku/compare/main...dev_update). Thank you 😁



## Tech Stack

**Client:** Flutter

**Server:** PHP
