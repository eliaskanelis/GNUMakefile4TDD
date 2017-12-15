#include "CppUTest/TestHarness.h"

#include "board.h"

TEST_GROUP( initsString )
{
	void setup()
	{
		//
	}

	void teardown()
	{
		//
	}
};

TEST( initsString, newInitIsBlank )
{
	STRCMP_EQUAL( "GNU/Linux PC", getBoardName() );
}