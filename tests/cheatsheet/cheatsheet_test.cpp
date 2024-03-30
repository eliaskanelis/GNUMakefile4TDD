#include "CppUTest/TestHarness.h"

#include "bsp.h"

TEST_GROUP( cheetsheet )
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

TEST( cheetsheet, board )
{
	STRCMP_EQUAL( "posix", bsp_getName() );
}

TEST( cheetsheet, Print )
{
	UT_PRINT( "Hello, world!" );
}

IGNORE_TEST( cheetsheet, FailonPurpose )
{
	/*
	 * Always fails
	 * FAIL(text)
	 */
	FAIL( "I would fail if the test was not gnored!" );
}

TEST( cheetsheet, General )
{
	/*
	 * Checks for equality between entities using ==.
	 * CHECK_EQUAL(expected, actual)
	 */
	CHECK_EQUAL( 1, 1 );
	CHECK_EQUAL( "Test", "Test" );
	CHECK_EQUAL_TEXT( "Test", "Test", "Test failed" );

	/*
	 * Checks thats a relational operator holds between two entities.
	 * On failure, prints what both operands evaluate to
	 * CHECK_COMPARE(first, relop, second)
	 */
	const double small = 0.5, big = 0.8;
	CHECK_COMPARE( big, >=, small );
	CHECK_COMPARE_TEXT( big, >=, small, "small bigger than big" );
}

TEST( cheetsheet, Boolean )
{
	/*
	 * Checks any boolean result
	 * CHECK(boolean condition)
	 */
	CHECK( 1U );
	CHECK( 0 != 1 );
	CHECK( true );
	CHECK( !false );
	CHECK_TEXT( true, "Check failed" );

	/*
	 * Checks any boolean result
	 * CHECK_TRUE(boolean condition)
	 */
	CHECK_TRUE( true );
	CHECK_TRUE_TEXT( true, "Check failed" );

	/*
	 * Checks any boolean result
	 * CHECK_FALSE(boolean condition)
	 */
	CHECK_FALSE( false );
	CHECK_FALSE_TEXT( false, "Test failed" );
}

TEST( cheetsheet, Bits_1bit )
{
	/*
	 * Compares expected to actual bit by bit, applying mask
	 * BITS_EQUAL(expected, actual, mask)
	 */
	BITS_EQUAL( 0x0001, ( unsigned short )0x0001, 0xFFFF );
	BITS_EQUAL( 0x01, ( unsigned char )0x01, 0xFF );
	BITS_EQUAL( 0x00000001, ( unsigned long )0x00000001, 0xFFFFFFFF );
	BITS_EQUAL_TEXT( 0x01, ( unsigned char )0x01, 0xFF, "Bits are not equal" );
}

TEST( cheetsheet, Bytes_8bit )
{
	const signed char v_signed = 0xFF;
	const unsigned char v_unsigned = 0xFF;

	/*
	 * Compares two numbers, eight bits wide
	 * BYTES_EQUAL(expected, actual)
	 */
	BYTES_EQUAL( 0, 256 );
	BYTES_EQUAL( 0x61, 'a' );
	BYTES_EQUAL( 'a', 'a' );
	BYTES_EQUAL( v_signed, v_unsigned );
	BYTES_EQUAL_TEXT( 'a', 'a', "Bytes are not equal" );

	/*
	 * Compares two numbers, eight bits wide
	 * BYTES_EQUAL(expected, actual)
	 */
	SIGNED_BYTES_EQUAL( -1, 255 );
	SIGNED_BYTES_EQUAL( v_signed, v_unsigned );
	SIGNED_BYTES_EQUAL_TEXT( -1, -1, "Bytes are not equal" );
}

TEST( cheetsheet, Long_32bit )
{
	/*
	 * Compares two numbers
	 * LONGS_EQUAL(expected, actual)
	 */
	LONGS_EQUAL( 1, 1 );
	LONGS_EQUAL( -1, -1 );
	LONGS_EQUAL( 0, 0xFFFFFFFF + 1 );
	LONGS_EQUAL_TEXT( 1, 1, "Test failed" );

	/*
	 * Compares two positive numbers
	 * UNSIGNED_LONGS_EQUAL(expected, actual)
	 */
	UNSIGNED_LONGS_EQUAL( 1, 1 );
	UNSIGNED_LONGS_EQUAL( -1, -1 );
	UNSIGNED_LONGS_EQUAL( 0, 0xFFFFFFFF + 1 );
	UNSIGNED_LONGS_EQUAL_TEXT( 1, 1, "Test failed" );

}

TEST( cheetsheet, Longlong_64bit )
{
	LONGLONGS_EQUAL( 0, 0xFFFFFFFFFFFFFFFF + 1 );
	LONGLONGS_EQUAL( 1, 1 );
	LONGLONGS_EQUAL_TEXT( 1, 1, "Test failed" );

	UNSIGNED_LONGLONGS_EQUAL( 1, 1 );
	UNSIGNED_LONGLONGS_EQUAL( 0, 0xFFFFFFFFFFFFFFFF + 1 );
	UNSIGNED_LONGLONGS_EQUAL_TEXT( 1, 1, "Test failed" );
}

TEST( cheetsheet, Float )
{
	/*
	 * Compares two floating point numbers within some tolerance
	 * DOUBLES_EQUAL(expected, actual, tolerance)
	 */
	DOUBLES_EQUAL( 1.000, 1.001, 0.01 );
	DOUBLES_EQUAL_TEXT( 1.000, 1.001, 0.01, "Floats are not withing tolerances" );
}

TEST( cheetsheet, Strings )
{
	/*
	 * Checks const char* strings for equality using strcmp()
	 * STRCMP_EQUAL(expected, actual)
	 */
	STRCMP_EQUAL( "hello", "hello" );
	STRCMP_EQUAL_TEXT( "hello", "hello", "Strings are not the same" );

	/*
	 * Checks const char* strings for equality using strncmp()
	 * STRNCMP_EQUAL(expected, actual, length)
	 */
	STRNCMP_EQUAL( "hello", "hello", 5 );
	STRNCMP_EQUAL_TEXT( "hello", "hello", 5, "Strings are not the same" );

	/*
	 * Checks const char* strings for equality, not considering case
	 * STRCMP_NOCASE_EQUAL(expected, actual)
	 */
	STRCMP_NOCASE_EQUAL( "hello", "HELLO" );
	STRCMP_NOCASE_EQUAL_TEXT( "hello", "HELLO", "Strings are not the same" );

	/*
	 * Checks whether const char* actual contains const char* expected
	 * STRCMP_CONTAINS(expected, actual)
	 */
	STRCMP_CONTAINS( "Hello", "Hello world" );
	STRCMP_CONTAINS_TEXT( "Hello", "Hello world", "Could not find string" );
}

TEST( cheetsheet, Pointers )
{
	/*
	 * Compares two pointers
	 * POINTERS_EQUAL(expected, actual)
	 */
	POINTERS_EQUAL( ( void * )0xa5a5, ( void * )0xa5a5 );

	char *p = "Hello";
	POINTERS_EQUAL( p, &p[0] );
	POINTERS_EQUAL( *p, p[0] );
	POINTERS_EQUAL_TEXT( *p, p[0], "Pointers are not equal" );
}

TEST( cheetsheet, FunctionPointers )
{
	/*
	 * Compares two void (*)() function pointers
	 * FUNCTIONPOINTERS_EQUAL(expected, actual)
	 */
	FUNCTIONPOINTERS_EQUAL( ( void ( * )() )0xbeef, ( void ( * )() )0xbeef );
	FUNCTIONPOINTERS_EQUAL_TEXT( ( void ( * )() )0xa5a5, ( void ( * )() )0xa5a5,
	                             "Function pointer not equal" );
}

TEST( cheetsheet, Memory )
{
	/*
	 * Compares two areas of memory
	 * MEMCMP_EQUAL(expected, actual, size)
	 */
	MEMCMP_EQUAL( "THIS", "THIS", 5 );
	MEMCMP_EQUAL_TEXT( "THIS", "THIS", 5, "Memory areas are not equal" );

	const int a[] = {1, 2, 3, 4, 5};
	const int b[] = {1, 2, 3, 4, 5, 6};
	MEMCMP_EQUAL_TEXT( &a[0], &b[0], 5 * sizeof( int ),
	                   "Memory areas are not equal" );
}

TEST( cheetsheet, Not_used )
{
	//CHECK_THROWS(expected_exception, expression) - checks if expression throws expected_exception (e.g. std::exception). CHECK_THROWS is only available if CppUTest is built with the Standard C++ Library (default).
	//CHECK_TEST_FAILS_PROPER_WITH_TEXT( "expected <1 (0x1)>" );
}
