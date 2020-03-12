# apex-csv

An sfdx project containing some Apex classes for dealing with CSV ("comma separated values") files within Salesforce.

## Serializing data to CSV
## Features
* Enforces consistent number of cells in each row
* Handles escaping of separator (comma by default), newlines and quotes
* Configurable separator, null handling, and date format.
## Usage
```apex
    CsvWriter writer = new CsvWriter();
    String csvString = writer
        .AddRow()
        .AddCell('A1')
        .AddCell('B1')
        .AddCell('C1')
        .CloseRow()
        .AddCell('A2')
        .AddBlankCells(2)
        .CloseRow()
        .Build();
    System.debug(csvString);
    // 'A1,B1,C1\nA2,,'

```

## Deserializing a CSV file to SObjects

Coming soon!

## Features
* Configure mappings in Custom Settings - new mappings can be adding without touching any code.
* Allows flexibility in the source CSV file
    * Header row doesn't need to be first row
    * Columns can be in any order, as long as the column headers match the headers defined in the Custom Setting
    * Define optional and required columns
* Handles lookup and Master/Detail relationships

## Installing

This project is a standard sfdx project. Clone it to your local machine with `git clone https://github.com/stephanspiegel/apex-csv`
Then deploy it to a scratch org using `sfdx force:source:push` from within the project directory.