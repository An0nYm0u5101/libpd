//
//  PdFile.m
//  libpd
//
//  Created by Richard Eakin on 21/02/11.
//
//  Copyright (c) 2011 Richard Eakin (reakinator@gmail.com)
//
//  For information on usage and redistribution, and for a DISCLAIMER OF ALL
//  WARRANTIES, see the file, "LICENSE.txt," in this distribution.
//

#import "PdFile.h"
#import "z_libpd.h"

@interface PdFile ()

@property (nonatomic, retain) NSValue *fileReference;
@property (nonatomic, assign) int dollarZero;
@property (nonatomic, copy) NSString *baseName;
@property (nonatomic, copy) NSString *pathName;

@end

@implementation PdFile

@synthesize fileReference = fileReference_;
@synthesize dollarZero = dollarZero_;
@synthesize baseName = baseName_;
@synthesize pathName = pathName_;

#pragma mark -
#pragma mark - Class Open method

+ (id)openFileNamed:(NSString *)baseName path:(NSString *)pathName {
	PdFile *pdFile = [[[self alloc] init] autorelease];
	if (pdFile) {
		[pdFile openFile:baseName path:pathName];
		if (![pdFile fileReference]) {
			return nil;
		}
	}
	return pdFile;
}

#pragma mark -
#pragma mark - Dealloc

- (void)dealloc {
	[self closeFile]; 
	self.pathName = nil;
	self.baseName = nil;
	self.fileReference = nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark - Public Open / Close methods

- (void)openFile:(NSString *)baseName path:(NSString *)pathName {
	if (!baseName || !pathName) {
		return;
	}
	self.baseName = baseName;
	self.pathName = pathName;

	const char *base = [baseName cStringUsingEncoding:NSASCIIStringEncoding];
	const char *path = [pathName cStringUsingEncoding:NSASCIIStringEncoding];
	void *x = libpd_openfile(base, path);
	if (x) {
		self.fileReference = [NSValue valueWithPointer:x]; 
		self.dollarZero = libpd_getdollarzero(x);
	}
}

- (void)closeFile {
	void *x = [self.fileReference pointerValue];
	if (x) {
		libpd_closefile(x);
		self.fileReference = nil;
	}
}

@end
