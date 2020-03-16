package com.profidata.eclipse.egerrit.patch.aspects;

import org.apache.http.client.utils.URIBuilder;
import org.aspectj.lang.annotation.SuppressAjWarnings;
import org.eclipse.egerrit.internal.core.GerritRepository;

public privileged aspect GerritRepositoryPatch {
	@SuppressAjWarnings("adviceDidNotMatch")
	URIBuilder around(boolean theRequiresAuthentication): 
		execution(public URIBuilder GerritRepository.getURIBuilder(boolean))  && 
		target(GerritRepository) && args(theRequiresAuthentication) {
		GerritRepository aGerritRepository = (GerritRepository) thisJoinPoint.getTarget();

		// Build the path
		StringBuilder sb = new StringBuilder(aGerritRepository.fPath);
		if (theRequiresAuthentication) {
			sb.append("/a");
		}
		String path = sb.toString();

		URIBuilder builder = new EGerritURIBuilder().setScheme(aGerritRepository.fScheme).setHost(aGerritRepository.fHostname).setPath(path);
		if (aGerritRepository.fPort > 0) {
			builder.setPort(aGerritRepository.fPort);
		}

		return builder;
	}
	
	private static class EGerritURIBuilder extends URIBuilder {
		@Override
		public String getPath() {
			String aPath = super.getPath();
			
			return (aPath == null) ? "" : aPath;
		}
		
	}
}
