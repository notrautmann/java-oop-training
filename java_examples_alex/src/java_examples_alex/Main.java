package java_examples_alex;

import java.io.IOException;

import event_example.EventDemo;
import exception_example.ExceptionVsLogik;
import mediator_example.MediatorDemo;
import memento_example.MementoDemo;
import observer_example.ObserverDemo;
import state_example.StateDemo;
import strategy_examples.StrategyDemo;
import templatemethod_example.TemplatemethodDemo;
import visitor_example.VisitorDemo;

/**
 * Entry point class for running various example demos in the java_examples_alex package.
 */
public class Main {

	/**
	 * Application entry point.
	 * @param args the command line arguments
	 */
	public static void main(String[] args) {
		// CompositeDemo.run();
		// DecoratorDemo.run();
		// FacadeDemo.start();
		// FlyweightDemo.run();
		// ProxyDemo.run();
		// ChainOfResponsibilityDemo.run();
		// CommandDemo.run();
		// IteratorDemo.run();
		// MediatorDemo.run();
		// MementoDemo.run();
		// ObserverDemo.run();
		// StateDemo.run();
		// StrategyDemo.run();
		// TemplatemethodDemo.run();
		// VisitorDemo.run();
		// NullObjects.run();
		// OptionalDemo.run();
		// StringDemo.run2();
		// UUIDDemo.run();
		/*try {
			FileDemo.run();
		} catch (IOException e) {
			e.printStackTrace();
		}*/
		//EventDemo.run();
		ExceptionVsLogik.run();
	}

}
