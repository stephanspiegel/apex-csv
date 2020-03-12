@isTest
private class CsvWriterTest
{
    @isTest
    static void itShouldAddCellsCorrectly()
    {
        // Given
        CsvWriter writer = new CsvWriter();

        // When
        String actual = writer
            .AddRow()
            .AddCell('A')
            .AddCell('B')
            .AddCell('C')
            .CloseRow()
            .Build();
        String expected = 'A,B,C';
        // Then
        System.AssertEquals(expected, actual, 'CsvWriter should add three cell values together correctly.');

    }

    @isTest
    static void itShouldAddRowsCorrectly()
    {
        // Given
        CsvWriter writer = new CsvWriter();

        // When
        String actual = writer
            .AddRow()
            .AddCell('A')
            .CloseRow()
            .AddRow()
            .AddCell('B')
            .CloseRow()
            .Build();
        String expected = 'A\nB';
        // Then
        System.AssertEquals(expected, actual, 'CsvWriter should add two rows correctly.');

    }
    @isTest
    static void itShouldAddBlankCellsCorrectly()
    {
        // Given
        CsvWriter writer = new CsvWriter();

        // When
        String actual = writer
            .AddRow()
            .AddCell()
            .AddCell('')
            .AddCell()
            .CloseRow()
            .Build();
        String expected = ',,';
        // Then
        System.AssertEquals(expected, actual, 'CsvWriter should add blank cells correctly.');

    }
    @isTest
    static void itShouldAddBlankCellsInBulk()
    {
        // Given
        CsvWriter writer = new CsvWriter();

        // When
        String actual = writer
            .AddRow()
            .AddBlankCells(5)
            .CloseRow()
            .Build();
        String expected = ',,,,';
        // Then
        System.AssertEquals(expected, actual, 'CsvWriter should add blank cells in bulk correctly.');

    }
    @isTest
    static void itShouldAddDatesCorrectly()
    {
        // Given
        CsvWriter.Options options = new CsvWriter.Options();
        options.dateFormat = 'yyyy.MM.dd';
        CsvWriter writer = new CsvWriter(options);
        Date sampleDate = Date.newInstance(2017, 08, 21);
        // When
        String actual = writer
            .AddRow()
            .AddCell(sampleDate)
            .CloseRow()
            .Build();
        String expected = '2017.08.21';
        // Then
        System.AssertEquals(expected, actual, 'CsvWriter should add date values in the correct format.');

    }
    @isTest
    static void itShouldAddDateTimesCorrectly()
    {
        // Given
        CsvWriter writer = new CsvWriter();
        DateTime sampleDate = DateTime.newInstance(2017, 08, 21, 11, 10, 07);
        // When
        String actual = writer
            .AddRow()
            .AddCell(sampleDate)
            .CloseRow()
            .Build();
        String expected = '08/21/2017';
        // Then
        System.AssertEquals(expected, actual, 'CsvWriter should add datetime values in the correct format.');

    }
    @isTest
    static void itShouldAddDecimalsCorrectly()
    {
        // Given
        CsvWriter writer = new CsvWriter();
        // When
        String actual = writer
            .AddRow()
            .AddCell(1.12)
            .AddCell(74.57)
            .CloseRow()
            .Build();
        String expected = '1.12,74.57';
        // Then
        System.AssertEquals(expected, actual, 'CsvWriter should add date values in the correct format.');

    }
    @isTest
    static void itShouldEscapeCommasCorrectly()
    {
        // Given
        CsvWriter writer = new CsvWriter();

        // When
        String actual = writer
            .AddRow()
            .AddCell('This, that or the other')
            .AddCell('one, two, three')
            .CloseRow()
            .Build();
        String expected = '"This, that or the other","one, two, three"';
        // Then
        System.AssertEquals(expected, actual, 'CsvWriter should put quotes around cell values containing commas.');

    }
    @isTest
    static void itShouldEscapeQuotesCorrectly()
    {
        // Given
        CsvWriter writer = new CsvWriter();

        // When
        String actual = writer
            .AddRow()
            .AddCell('This cell "contains quoted" text')
            .AddCell('height: 5"9\'')
            .CloseRow()
            .Build();
        String expected = '"This cell ""contains quoted"" text","height: 5""9\'"';
        // Then
        System.AssertEquals(expected, actual, 'CsvWriter should put quotes around cell values containing quotes, and double up quotes inside the cell.');

    }
    @isTest
    static void itShouldEscapeNewlinesCorrectly()
    {
        // Given
        CsvWriter writer = new CsvWriter();

        // When
        String actual = writer
            .AddRow()
            .AddCell('This cell contains\na line break')
            .AddCell('Another\r\nbreak')
            .CloseRow()
            .Build();
        String expected = '"This cell contains\na line break","Another\r\nbreak"';
        // Then
        System.AssertEquals(expected, actual, 'CsvWriter should put quotes around cell values containing line breaks.');

    }

    @isTest
    static void itShouldThrowExceptionWhenColumnCountIsOff()
    {
        // Given
        CsvWriter writer = new CsvWriter();
        String actual;
        // When
        try {
            String writerOutput = writer
                .AddRow()
                .AddCell('A')
                .AddCell('B')
                .AddCell('C')
                .CloseRow()
                .AddRow()
                .AddCell('D')
                .AddCell('E')
                .CloseRow()
                .Build();
        } catch(CsvWriter.CsvWriterException ex){
            actual = ex.getMessage();
        }
        String expected = 'Row 2 has 2 cells instead of the expected 3.';
        // Then
        System.AssertEquals(expected, actual, 'CsvWriter should throw an exception if a row has different cell count from other rows.');

    }

    @isTest
    static void itShouldReplaceLiteralNulls()
    {
        // Given
        CsvWriter writer = new CsvWriter();
        String nullString = null;
        // When
        String actual = writer
            .AddRow()
            .AddCell('null')
            .AddCell('NULL')
            .AddCell('')
            .AddCell(nullString)
            .AddCell('Snullinger')
            .CloseRow()
            .Build();

        String expected = ',,,,Snullinger';
        // Then
        System.AssertEquals(expected, actual, 'CsvWriter should blank out cells if they consist of only \'null\'.');

    }

    @isTest
    static void itShouldBuildEmptyStringIfNoRowsAdded(){
        CsvWriter writer = new CsvWriter();
        Test.startTest();
        String actual = writer.Build();
        Test.stopTest();
        String expected = '';
        System.assertEquals(expected, actual, 'Build() didn\'t return empty string when no rows were added');
    }
}