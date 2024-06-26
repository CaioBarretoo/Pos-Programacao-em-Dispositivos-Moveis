package br.edu.utfpr.consbustivel

import androidx.test.espresso.Espresso
import androidx.test.espresso.action.ViewActions
import androidx.test.espresso.assertion.ViewAssertions
import androidx.test.espresso.matcher.ViewMatchers
import androidx.test.espresso.matcher.ViewMatchers.withId
import androidx.test.ext.junit.rules.ActivityScenarioRule
import androidx.test.platform.app.InstrumentationRegistry
import androidx.test.ext.junit.runners.AndroidJUnit4

import org.junit.Test
import org.junit.runner.RunWith

import org.junit.Assert.*
import org.junit.Rule
import org.junit.matchers.JUnitMatchers

/**
 * Instrumented test, which will execute on an Android device.
 *
 * See [testing documentation](http://d.android.com/tools/testing).
 */
@RunWith(AndroidJUnit4::class)
class ExampleInstrumentedTest {

    @get:Rule()
    val activity = ActivityScenarioRule(MainActivity::class.java)
    @Test
    fun useAppContext() {
        Espresso.onView(withId(R.id.etFuel1))
            .perform(ViewActions.typeText("10.00"))
            .perform(ViewActions.closeSoftKeyboard())

        Espresso.onView(withId(R.id.etFuel2))
            .perform(ViewActions.typeText("5.00"))
            .perform(ViewActions.closeSoftKeyboard())

        Espresso.onView(withId(R.id.etMoney1))
            .perform(ViewActions.typeText("10.00"))
            .perform(ViewActions.closeSoftKeyboard())

        Espresso.onView(withId(R.id.etMoney2))
            .perform(ViewActions.typeText("10.00"))
            .perform(ViewActions.closeSoftKeyboard())

        Espresso.onView(withId(R.id.btCalcular))
            .perform(ViewActions.click())

        Espresso.onView(withId(R.id.etResult))
            .check(ViewAssertions.matches(ViewMatchers.withText(JUnitMatchers.containsString("Abasteça com o 1°"))))
    }
}