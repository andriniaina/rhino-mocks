using Castle.Core.Interceptor;
using andri.Mocks.Impl.InvocationSpecifications;

namespace andri.Mocks.Impl.Invocation.Specifications
{
    ///<summary>
    ///</summary>
    public class IsAnEventInvocation : ISpecification<IInvocation>
    {
        ///<summary>
        ///</summary>
        public bool IsSatisfiedBy(IInvocation item)
        {
            return new AndSpecification<IInvocation>(new FollowsEventNamingStandard(),
                                                     new NamedEventExistsOnDeclaringType()).IsSatisfiedBy(item);
        }
    }

    ///<summary>
    ///</summary>
    public class AnyInvocation : ISpecification<IInvocation>
    {
        ///<summary>
        ///</summary>
        public bool IsSatisfiedBy(IInvocation item)
        {
            return true;
        }
    }
}