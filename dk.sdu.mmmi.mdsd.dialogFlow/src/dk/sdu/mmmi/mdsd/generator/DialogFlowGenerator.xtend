/*
 * generated by Xtext 2.25.0
 */
package dk.sdu.mmmi.mdsd.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.mmmi.mdsd.dialogFlow.DialogFlowSystem
import dk.sdu.mmmi.mdsd.dialogFlow.Entity
import dk.sdu.mmmi.mdsd.dialogFlow.Intent
import java.util.List

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class DialogFlowGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val systemList = resource.allContents.filter(DialogFlowSystem).toList
		
		for(system: systemList) {
			val rootElementCreator = new RootElementCreator(system.name)
			rootElementCreator.generateElements(system, fsa)
		
			val entityCreator = new EntityCreator(system.name)
			val intentCreator = new IntentCreator(system.name)
			
			val systemDeclarations = system.declarations
			
			for(d: systemDeclarations) {
				if(d instanceof Entity) {
					entityCreator.generateEntity(d, fsa)
				} else if(d instanceof Intent) {
					intentCreator.generateIntent(d, fsa)
				}
			}
			
			if(system.superSystem !== null) {
				identifySupers(system.superSystem, systemList, entityCreator, intentCreator, fsa)
			}
			
			generateSystem(system, resource, fsa)
		}
		
	}
	
	def identifySupers(DialogFlowSystem superSystem, List<DialogFlowSystem> systemList,
		EntityCreator entityCreator, IntentCreator intentCreator, IFileSystemAccess2 fsa) {
			
		generateSuperArtefacts(superSystem, entityCreator, intentCreator, fsa)
			
		if(superSystem.superSystem !== null) {
			identifySupers(superSystem.superSystem, systemList, entityCreator, intentCreator, fsa)
		} 
	}
	
	def generateSuperArtefacts(DialogFlowSystem system, EntityCreator entityCreator,
		IntentCreator intentCreator, IFileSystemAccess2 fsa) {
			
		val systemDeclarations = system.declarations

		for(d: systemDeclarations) {
			if(d instanceof Entity) {
				entityCreator.generateEntity(d, fsa)
			} else if(d instanceof Intent) {
				intentCreator.generateIntent(d, fsa)
			}
		}
	}
	
	
	def generateSystem(DialogFlowSystem system, Resource resource, IFileSystemAccess2 fsa) {
		
		val systemDeclarations = system.declarations

		val entityCreator = new EntityCreator(system.name)
		val intentCreator = new IntentCreator(system.name)
		for(d: systemDeclarations) {
			if(d instanceof Entity) {
				entityCreator.generateEntity(d, fsa)
			} else if(d instanceof Intent) {
				intentCreator.generateIntent(d, fsa)
			}
		}
	
	}
	
}
